#!/bin/bash

set -e

# Version
version="0.65.1"
# Download pre-built binaries of fzf
wget https://github.com/junegunn/fzf/releases/download/v$version/fzf-$version-linux_amd64.tar.gz
# Extract the archive
mkdir -p ~/.local/fzf.app
tar -C ~/.local/fzf.app -xzf fzf-$version-linux_amd64.tar.gz
# Create symbolic links to add fzf to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
mkdir -p ~/.local/bin
ln -sf ~/.local/fzf.app/fzf ~/.local/bin/
# Delete archive
rm -rf fzf-$version-linux_amd64.tar.gz
