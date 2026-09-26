#!/usr/bin/env bash
# FtVim installer: Neovim, ripgrep, a Nerd Font, the 42 tools and the starter config.
# Everything goes to your home directory, no root needed (works on 42 campus machines).
#
#   curl -fsSL https://raw.githubusercontent.com/FtVim/FtVim/main/scripts/install.sh | bash
#
# Options (after `bash -s --` when piping):
#   --data-dir DIR   keep plugins/caches in DIR (e.g. your sgoinfre) to save home quota
#   --prefix DIR     where to install binaries (default: ~/.local)
#   --no-font        don't install JetBrainsMono Nerd Font
#   --no-42          don't install norminette, c_formatter_42 and compiledb
#   --no-starter     don't install the starter config in ~/.config/nvim

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/FtVim/FtVim/main"
STARTER_REPO="https://github.com/FtVim/starter"
PREFIX="$HOME/.local"
DATA_DIR=""
INSTALL_FONT=1
INSTALL_42=1
INSTALL_STARTER=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --data-dir)
      DATA_DIR="$2"
      shift
      ;;
    --prefix)
      PREFIX="$2"
      shift
      ;;
    --no-font) INSTALL_FONT=0 ;;
    --no-42) INSTALL_42=0 ;;
    --no-starter) INSTALL_STARTER=0 ;;
    -h | --help)
      echo "Usage: install.sh [--data-dir DIR] [--prefix DIR] [--no-font] [--no-42] [--no-starter]"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

export INSTALL_PREFIX="$PREFIX"
export PATH="$PREFIX/bin:$PATH"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

function step() {
  printf '\n\033[1;32m==>\033[0m \033[1m%s\033[0m\n' "$*"
}

function warn() {
  printf '\033[1;33mWarning:\033[0m %s\n' "$*"
}

# Runs one of the helper scripts, from this checkout or downloaded from GitHub
function run_helper() {
  local name="$1"
  local dir
  dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
  if [[ -n "$dir" && -f "$dir/$name" ]]; then
    bash "$dir/$name"
  else
    curl -fsSL "$REPO_RAW/scripts/$name" -o "$WORK_DIR/$name"
    bash "$WORK_DIR/$name"
  fi
}

function nvim_is_recent() {
  command -v nvim >/dev/null 2>&1 &&
    nvim --headless --clean "+lua io.stdout:write(vim.fn.has('nvim-0.11'))" +qa 2>/dev/null | grep -q 1
}

function install_neovim() {
  step "Neovim"
  if nvim_is_recent; then
    echo "Neovim >= 0.11 already installed: $(command -v nvim)"
  else
    run_helper install-neovim.sh
  fi
}

function install_ripgrep() {
  step "ripgrep"
  if command -v rg >/dev/null 2>&1; then
    echo "ripgrep already installed: $(command -v rg)"
  else
    run_helper install-ripgrep.sh
  fi
}

function install_font() {
  step "JetBrainsMono Nerd Font"
  local font_dir
  if [[ "$(uname -s)" == "Darwin" ]]; then
    font_dir="$HOME/Library/Fonts"
  else
    font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMonoNerdFont"
  fi
  if ls "$font_dir"/JetBrainsMonoNerdFont-* >/dev/null 2>&1; then
    echo "Already installed in $font_dir"
    return
  fi
  mkdir -p "$font_dir"
  curl --progress-bar -fL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" \
    -o "$WORK_DIR/font.tar.xz"
  tar -xJf "$WORK_DIR/font.tar.xz" -C "$font_dir" --wildcards "JetBrainsMonoNerdFont-*.ttf" 2>/dev/null ||
    tar -xJf "$WORK_DIR/font.tar.xz" -C "$font_dir"
  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$font_dir" >/dev/null
  fi
  echo "Installed in $font_dir. Select \"JetBrainsMono Nerd Font\" in your terminal settings."
}

function install_42_tools() {
  step "norminette, c_formatter_42 and compiledb"
  local missing=()
  command -v norminette >/dev/null 2>&1 || missing+=(norminette)
  command -v c_formatter_42 >/dev/null 2>&1 || missing+=(c-formatter-42)
  command -v compiledb >/dev/null 2>&1 || missing+=(compiledb)
  if [[ ${#missing[@]} -eq 0 ]]; then
    echo "Already installed"
    return
  fi
  if command -v pipx >/dev/null 2>&1; then
    for pkg in "${missing[@]}"; do
      pipx install "$pkg" || warn "pipx install $pkg failed"
    done
  elif command -v python3 >/dev/null 2>&1; then
    python3 -m pip install --user --upgrade "${missing[@]}" ||
      warn "pip failed. Try: pipx install ${missing[*]}"
  else
    warn "python3 not found, skipping ${missing[*]}"
  fi
}

# Moves ~/.local/share/nvim and ~/.cache/nvim to DATA_DIR and leaves symlinks behind
function link_data_dir() {
  step "Data directory: $DATA_DIR"
  local share="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"
  local dir target
  for pair in "$share:nvim-data" "$cache:nvim-cache"; do
    dir="${pair%%:*}"
    target="$DATA_DIR/${pair##*:}"
    mkdir -p "$target" "$(dirname "$dir")"
    if [[ -L "$dir" ]]; then
      echo "$dir is already a link to $(readlink "$dir")"
      continue
    fi
    if [[ -d "$dir" ]]; then
      cp -R "$dir/." "$target/"
      rm -rf "$dir"
    fi
    ln -s "$target" "$dir"
    echo "$dir -> $target"
  done
}

function install_starter() {
  step "Starter config"
  local config="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  if [[ -d "$config/.git" ]] && git -C "$config" remote get-url origin 2>/dev/null | grep -qi "ftvim/starter"; then
    echo "FtVim starter already installed in $config"
    return
  fi
  if [[ -e "$config" ]]; then
    local backup
    backup="$config.bak.$(date +%Y%m%d%H%M%S)"
    mv "$config" "$backup"
    echo "Your previous config was moved to $backup"
  fi
  git clone --depth 1 "$STARTER_REPO" "$config"
}

function add_to_path() {
  local line="export PATH=\"$PREFIX/bin:\$PATH\""
  local updated=0
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    if [[ -f "$rc" ]] && ! grep -qF "$PREFIX/bin" "$rc"; then
      printf '\n# Added by the FtVim installer\n%s\n' "$line" >>"$rc"
      echo "Added $PREFIX/bin to PATH in $rc"
      updated=1
    fi
  done
  if [[ $updated -eq 0 ]] && ! grep -qsF "$PREFIX/bin" "$HOME/.zshrc" "$HOME/.bashrc"; then
    warn "Add this to your shell config: $line"
  fi
}

install_neovim
install_ripgrep
[[ $INSTALL_FONT -eq 1 ]] && install_font
[[ $INSTALL_42 -eq 1 ]] && install_42_tools
[[ -n "$DATA_DIR" ]] && link_data_dir
[[ $INSTALL_STARTER -eq 1 ]] && install_starter
step "PATH"
add_to_path

step "Done!"
echo "Open a new terminal and run: nvim"
echo "Then run :checkhealth ftvim to see if anything is missing."
if [[ -z "${USER42:-}" ]]; then
  echo "For the 42 header, add to your shell config: export USER42=<login> MAIL42=<login>@student.42barcelona.com"
fi
