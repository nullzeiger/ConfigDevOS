#!/bin/bash

set -e

# Version
version="0.54.2"
# Download pre-built binaries of lazygit
wget https://github.com/jesseduffield/lazygit/releases/download/v$version/lazygit_${version}_Linux_x86_64.tar.gz
# Extract the archive
mkdir ~/.local/lazygit.app
tar -C ~/.local/lazygit.app -xzf lazygit_${version}_Linux_x86_64.tar.gz
# Create symbolic links to add lazygit to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
mkdir -p ~/.local/bin
ln -sf ~/.local/lazygit.app/lazygit ~/.local/bin/
# Delete archive
rm -rf lazygit_${version}_Linux_x86_64.tar.gz

