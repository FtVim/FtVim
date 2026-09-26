#!/usr/bin/env bash
# Installs a Neovim release into $INSTALL_PREFIX (default: ~/.local) without root.
# Usage: RELEASE_VER=v0.11.5 INSTALL_PREFIX=~/.local ./install-neovim.sh

set -euo pipefail

declare -r INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"
declare RELEASE_VER="${RELEASE_VER:-v0.11.5}"
declare -r REPO="neovim/neovim"

declare OS ARCH ARCHIVE_NAME
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64 | amd64) ARCH="x86_64" ;;
  aarch64 | arm64) ARCH="arm64" ;;
  *)
    echo "$ARCH architecture is not supported currently"
    exit 1
    ;;
esac

case "$OS" in
  Linux) ARCHIVE_NAME="nvim-linux-${ARCH}" ;;
  Darwin) ARCHIVE_NAME="nvim-macos-${ARCH}" ;;
  *)
    echo "$OS platform is not supported currently"
    exit 1
    ;;
esac

DOWNLOAD_DIR="$(mktemp -d)"
readonly DOWNLOAD_DIR
trap 'rm -rf "$DOWNLOAD_DIR"' EXIT

function sha256() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

# Prints the release metadata from the GitHub API
function release_json() {
  local path="tags/$RELEASE_VER"
  [[ "$RELEASE_VER" == "latest" ]] && path="latest"
  curl -fsSL "https://api.github.com/repos/$REPO/releases/$path"
}

function main() {
  local json expected_sha actual_sha
  json="$(release_json)" || {
    echo "Could not find release $RELEASE_VER"
    exit 1
  }
  RELEASE_VER="$(printf '%s' "$json" | tr ',' '\n' | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n1)"
  # GitHub publishes a sha256 digest for every release asset
  expected_sha="$(printf '%s' "$json" | tr ',' '\n' |
    awk -v name="\"$ARCHIVE_NAME.tar.gz\"" '$0 ~ "\"name\": *" name { found = 1 } found && /"digest"/ { print; exit }' |
    sed -n 's/.*sha256:\([0-9a-f]*\).*/\1/p')"

  local url="https://github.com/$REPO/releases/download/$RELEASE_VER/$ARCHIVE_NAME.tar.gz"
  echo "Downloading Neovim $RELEASE_VER ($ARCHIVE_NAME).."
  if ! curl --progress-bar --fail -L "$url" -o "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz"; then
    echo "Download failed.  Check that the release/filename are correct."
    exit 1
  fi

  if [[ -n "$expected_sha" ]]; then
    echo "Verifying checksum.."
    actual_sha="$(sha256 "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz")"
    if [[ "$expected_sha" != "$actual_sha" ]]; then
      echo "Error! checksum mismatch."
      echo "Expected: $expected_sha but got: $actual_sha"
      exit 1
    fi
  else
    echo "Warning: no checksum published for this release, skipping verification."
  fi

  echo "Installing Neovim.."
  mkdir -p "$INSTALL_PREFIX"
  tar -xzf "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz" -C "$DOWNLOAD_DIR"
  cp -R "$DOWNLOAD_DIR/$ARCHIVE_NAME/." "$INSTALL_PREFIX"
  echo "Installation complete!"
  echo "Now you can run $INSTALL_PREFIX/bin/nvim"
}

main "$@"
