#!/bin/bash

set -e

# Download pre-built binaries of neovim
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
# Extract the archive
tar -C ~/.local -xzf nvim-linux-x86_64.tar.gz
# Rename to nvim.app
mv ~/.local/nvim-linux-x86_64 ~/.local/nvim.app
# Create symbolic links to add nvim to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
mkdir -p ~/.local/bin
ln -sf ~/.local/nvim.app/bin/nvim ~/.local/bin/
# Delete archive
rm -rf nvim-linux-x86_64.tar.gz
