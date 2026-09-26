#!/usr/bin/env bash
# Installs a ripgrep release into $INSTALL_PREFIX/bin (default: ~/.local/bin) without root.
# Usage: RELEASE_VER=15.2.0 INSTALL_PREFIX=~/.local ./install-ripgrep.sh

set -euo pipefail

declare -r INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"
declare RELEASE_VER="${RELEASE_VER:-15.2.0}"
declare -r REPO="BurntSushi/ripgrep"

declare OS ARCH TARGET
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64 | amd64) ARCH="x86_64" ;;
  aarch64 | arm64) ARCH="aarch64" ;;
  *)
    echo "$ARCH architecture is not supported currently"
    exit 1
    ;;
esac

case "$OS" in
  Linux) TARGET="${ARCH}-unknown-linux-musl" ;;
  Darwin) TARGET="${ARCH}-apple-darwin" ;;
  *)
    echo "$OS platform is not supported currently"
    exit 1
    ;;
esac

if [[ "$RELEASE_VER" == "latest" ]]; then
  RELEASE_VER="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | tr ',' '\n' |
    sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n1)"
fi

declare -r ARCHIVE_NAME="ripgrep-${RELEASE_VER}-${TARGET}"
declare -r RELEASE_URL="https://github.com/$REPO/releases/download/${RELEASE_VER}/${ARCHIVE_NAME}.tar.gz"

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

function main() {
  download_ripgrep
  verify_ripgrep
  install_ripgrep
}

function download_ripgrep() {
  echo "Downloading ripgrep $RELEASE_VER ($TARGET).."
  if ! curl --progress-bar --fail -L "$RELEASE_URL" -o "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz"; then
    echo "Download failed.  Check that the release/filename are correct."
    exit 1
  fi
  echo "Download complete!"
}

function verify_ripgrep() {
  echo "Verifying the download.."
  local expected actual
  expected="$(curl -fsSL "$RELEASE_URL.sha256" | awk '{print $1}')"
  actual="$(sha256 "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz")"

  if [[ -z "$expected" || "$expected" != "$actual" ]]; then
    echo "Error! checksum mismatch."
    echo "Expected: $expected but got: $actual"
    exit 1
  fi
  echo "Verification complete!"
}

function install_ripgrep() {
  echo "Installing ripgrep..."
  tar -xzf "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz" -C "$DOWNLOAD_DIR"
  mkdir -p "$INSTALL_PREFIX/bin" "$INSTALL_PREFIX/share/man/man1"
  cp "$DOWNLOAD_DIR/$ARCHIVE_NAME/rg" "$INSTALL_PREFIX/bin/rg"
  cp "$DOWNLOAD_DIR/$ARCHIVE_NAME/doc/rg.1" "$INSTALL_PREFIX/share/man/man1/rg.1"
  echo "Installation complete!"
  echo "Now you can run $INSTALL_PREFIX/bin/rg"
}

main "$@"
