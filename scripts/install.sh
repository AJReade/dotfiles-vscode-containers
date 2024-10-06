#!/bin/bash

echo "Alex's dotfile script running now..."
# Ensure we are in the dotfiles directory (parent of this script)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR"

# Install necessary packages for Alpine Linux using apk
echo "Installing necessary packages for Alpine Linux..."
sudo apk update
sudo apk add fd fzf p7zip stow busybox-extras tree

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
