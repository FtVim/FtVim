#!/usr/bin/env bash

set -eu pipefall

declare -r INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"
declare -r RELEASE_VER="${RELEASE_VER:-v0.11.5}"

declare ARCHIVE_NAME
declare OS

OS="$(uname -s)"

if [ "$OS" == "Linux" ]; then
  ARCHIVE_NAME="nvim-linux-x86_64"
elif [ "$OS" == "Darwin" ]; then
  ARCHIVE_NAME="nvim-macos-x86_64"
else
  echo "$OS platform is not supported currently"
  exit 1
fi


if [[ "${RELEASE_VER}" == "latest" ]]; then
  declare -r RELEASE_URL="https://github.com/neovim/neovim/releases/${RELEASE_VER}/download/${ARCHIVE_NAME}.tar.gz"
else
  declare -r RELEASE_URL="https://github.com/neovim/neovim/releases/download/${RELEASE_VER}/${ARCHIVE_NAME}.tar.gz"
fi

DOWNLOAD_DIR="$(mktemp -d)"
readonly DOWNLOAD_DIR

function main() {
  if [ ! -d "$INSTALL_PREFIX" ]; then
    mkdir -p "$INSTALL_PREFIX"
  fi
  download_neovim
  install_neovim
}

function download_neovim() {
  echo "Downloading Neovim's binary from $RELEASE_VER release.."
  if ! curl --progress-bar --fail -L "$RELEASE_URL" -o "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz"; then
    echo "Download failed.  Check that the release/filename are correct."
    exit 1
  fi
  echo "Download complete!"
}

function install_neovim() {
  echo "Installing Neovim.."
  pushd "$DOWNLOAD_DIR"
  tar -xzf "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz"
  popd
  cp -r "$DOWNLOAD_DIR/$ARCHIVE_NAME/." "$INSTALL_PREFIX"
  echo "Installation complete!"
  echo "Now you can run $INSTALL_PREFIX/bin/nvim"
}

main "$@"
