#!/bin/bash

echo "Alex's dotfile script running now..."

# Ensure we are in the dotfiles directory (parent of this script)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR"

# Update and install necessary Linux packages using apt
echo "Updating package list and installing necessary Linux packages..."
sudo apt update

# List of packages to install
PACKAGES=(
    fd-find
    fzf
    p7zip-full
    stow
    telnet
    tree
)

# Install packages
for pkg in "${PACKAGES[@]}"; do
    sudo apt install -y "$pkg"
done

# List of files to symlink
FILES=(".fzf.zsh" ".gitconfig" ".vimrc" ".zshrc")

# Create symlinks for each config file
for file in "${FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
        echo "Backing up existing $file in home directory..."
        mv "$HOME/$file" "$HOME/$file.backup"
    fi
    echo "Creating symlink for $file..."
    ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
done

echo "Dotfiles successfully installed."

# Install VSCode extensions using the code CLI
echo "Installing VSCode extensions..."

# Check if the `code` command is available
if ! command -v code &> /dev/null
then
    echo "'code' command not found! Please ensure Visual Studio Code is installed and the 'code' CLI is enabled."
    exit 1
fi

# List of VSCode extensions to install
EXTENSIONS=(
    eamodio.gitlens
    ionutvmi.path-autocomplete
    mhutchie.git-graph
    mikeylau.typewriter-auto-scroll
    mrmlnc.vscode-duplicate
    ms-vsliveshare.vsliveshare
    oderwat.indent-rainbow
    rebornix.toggle
    redhat.vscode-yaml
    silesky.toggle-boolean
    streetsidesoftware.code-spell-checker
    tabnine.tabnine-vscode
)

# Install each VSCode extension
for ext in "${EXTENSIONS[@]}"; do
    code --install-extension "$ext"
done

echo "VSCode extensions successfully installed."
