#!/usr/bin/env bash

set -eu pipefall

declare -r INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"
declare -r RELEASE_VER="${RELEASE_VER:-14.1.0}"

declare ARCHIVE_NAME
declare OS

OS="$(uname -s)"

if [ "$OS" == "Linux" ]; then
  ARCHIVE_NAME="ripgrep-${RELEASE_VER}-x86_64-unknown-linux-musl"
elif [ "$OS" == "Darwin" ]; then
  ARCHIVE_NAME="ripgrep-${RELEASE_VER}-x86_64-apple-darwin"
else
  echo "$OS platform is not supported currently"
  exit 1
fi

if [[ "${RELEASE_VER}" == "latest" ]]; then
  declare -r RELEASE_URL="https://github.com/BurntSushi/ripgrep/releases/${RELEASE_VER}/download/${ARCHIVE_NAME}.tar.gz"
else
  declare -r RELEASE_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RELEASE_VER}/${ARCHIVE_NAME}.tar.gz"
fi
declare -r CHECKSUM_URL="$RELEASE_URL.sha256"

DOWNLOAD_DIR="$(mktemp -d)"
readonly DOWNLOAD_DIR

RELEASE_SHA="$(curl -Ls "$CHECKSUM_URL" | awk '{print $1}')"
readonly RELEASE_SHA

function main() {
  if [ ! -d "$INSTALL_PREFIX" ]; then
    mkdir -p "$INSTALL_PREFIX"
  fi
  download_ripgrep
  verify_ripgrep
  install_ripgrep
}

function download_ripgrep() {
  echo "Downloading Ripgrep's binary from $RELEASE_URL release.."
  if ! curl --progress-bar --fail -L "$RELEASE_URL" -o "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz"; then
    echo "Download failed.  Check that the release/filename are correct."
    exit 1
  fi
  echo "Download complete!"
}

function verify_ripgrep() {
  echo "Verifying the installation.."
  DOWNLOADED_SHA="$(openssl dgst -sha256 "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz" | awk '{print $2}')"

  if [ "$RELEASE_SHA" != "$DOWNLOADED_SHA" ]; then
    echo "Error! checksum mismatch."
    echo "Expected: $RELEASE_SHA but got: $DOWNLOADED_SHA"
    exit 1
  fi
  echo "Verification complete!"
}


function install_ripgrep() {
  echo "Installing ripgrep..."
  pushd "$DOWNLOAD_DIR"
  tar -xzf "$DOWNLOAD_DIR/$ARCHIVE_NAME.tar.gz"
  popd
  cp -r "$DOWNLOAD_DIR/$ARCHIVE_NAME/." "$INSTALL_PREFIX"
  echo "Installation complete!"
  echo "Now you can run $INSTALL_PREFIX/bin/rg"
}

main "$@"
