#!/bin/bash

echo "Alex's dotfile script running now..."

# Ensure we are in the dotfiles directory (parent of this script)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR"

# Detect OS package manager
if command -v apt &> /dev/null; then
    PM="apt"
elif command -v brew &> /dev/null; then
    PM="brew"
elif command -v dnf &> /dev/null; then
    PM="dnf"
elif command -v pacman &> /dev/null; then
    PM="pacman"
else
    echo "No supported package manager found (apt, brew, dnf, pacman). Please install packages manually."
    exit 1
fi

# Install necessary packages
echo "Using package manager: $PM"
if [ "$PM" == "apt" ]; then
    sudo apt update
    sudo apt install -y fd-find fzf p7zip-full stow telnet tree
elif [ "$PM" == "brew" ]; then
    brew install fd fzf p7zip stow telnet tree
elif [ "$PM" == "dnf" ]; then
    sudo dnf install -y fd-find fzf p7zip stow telnet tree
elif [ "$PM" == "pacman" ]; then
    sudo pacman -Syu --noconfirm fd fzf p7zip stow inetutils telnet tree
fi

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
if ! command -v code &> /dev/null && ! command -v code-insiders &> /dev/null; then
    echo "'code' or 'code-insiders' command not found! Please ensure Visual Studio Code is installed and the 'code' CLI is enabled."
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
    if command -v code &> /dev/null; then
        code --install-extension "$ext"
    elif command -v code-insiders &> /dev/null; then
        code-insiders --install-extension "$ext"
    fi
done

echo "VSCode extensions successfully installed."
