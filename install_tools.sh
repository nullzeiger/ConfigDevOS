#!/usr/bin/env bash

set -euo pipefail

# Install required APT packages
install_packages() {
    local packages=("gcc" "gdb" "make" "valgrind" "curl" "git")

    echo "[INFO] Updating APT..."
    sudo apt update

    echo "[INFO] Installing packages: ${packages[*]}"
    sudo apt install -y "${packages[@]}"
}


# Install Go
install_go() {
    local version="1.25.4"
    local go_tar="go${version}.linux-amd64.tar.gz"

    echo "[INFO] Downloading Go $version..."
    wget "https://go.dev/dl/$go_tar"

    echo "[INFO] Removing old Go installation (if any)..."
    sudo rm -rf /usr/local/go

    echo "[INFO] Extracting Go..."
    sudo tar -C /usr/local -xzf "$go_tar"

    echo "[INFO] Updating PATH..."
    {
        echo 'export PATH=$PATH:/usr/local/go/bin'
        echo 'export PATH=$PATH:$HOME/go/bin'
    } >> ~/.profile

    echo "[INFO] Removing Go archive..."
    rm -f "$go_tar"
}


# Install Kitty terminal
install_kitty() {
    echo "[INFO] Installing Kitty..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    mkdir -p ~/.local/bin
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
    ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/

    mkdir -p ~/.local/share/applications
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/

    # Fix desktop entry paths
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

    mkdir -p ~/.config
    echo 'kitty.desktop' > ~/.config/xdg-terminals.list

    mkdir -p ~/.config/kitty
    cp kitty.conf ~/.config/kitty/
}


# Install Neovim
install_nvim() {
    local nvim_tar="nvim-linux-x86_64.tar.gz"

    echo "[INFO] Downloading Neovim..."
    wget "https://github.com/neovim/neovim/releases/latest/download/$nvim_tar"

    echo "[INFO] Extracting Neovim..."
    tar -C ~/.local -xzf "$nvim_tar"

    echo "[INFO] Renaming to nvim.app..."
    mv ~/.local/nvim-linux-x86_64 ~/.local/nvim.app

    mkdir -p ~/.local/bin
    ln -sf ~/.local/nvim.app/bin/nvim ~/.local/bin/

    echo "[INFO] Removing archive..."
    rm -f "$nvim_tar"

    mkdir -p ~/.config/nvim
    cp init.lua ~/.config/nvim/
}


# main
main() {
    install_packages
    install_go
    install_kitty
    install_nvim

    echo
    echo " Installation completed successfully!"
}

main "$@"

