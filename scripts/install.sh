#!/bin/bash

echo "Alex's dotfile script running now..."
#!/bin/bash

# Ensure we are in the dotfiles directory (parent of this script)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR"

# Detect the operating system and install necessary package manager if needed
OS=$(uname -s)

# Function to install Homebrew on macOS or Linux if not available
install_brew() {
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -eq 0 ]; then
        echo "Homebrew installed successfully."
        # Ensure brew is in the PATH
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" || eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew installation failed. Please install it manually."
        exit 1
    fi
}

# Detect OS and install necessary package manager
case "$OS" in
    Linux)
        if command -v apt &> /dev/null; then
            PM="apt"
        elif command -v dnf &> /dev/null; then
            PM="dnf"
        elif command -v pacman &> /dev/null; then
            PM="pacman"
        elif command -v brew &> /dev/null; then
            PM="brew"
        else
            echo "No package manager found. Installing Homebrew..."
            install_brew
            PM="brew"
        fi
        ;;
    Darwin)
        # For macOS, use Homebrew
        if command -v brew &> /dev/null; then
            PM="brew"
        else
            install_brew
            PM="brew"
        fi
        ;;
    *)
        echo "Unsupported OS: $OS. Exiting."
        exit 1
        ;;
esac

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

# Function to add the VSCode CLI to PATH
add_code_to_path() {
    echo "Adding 'code' command to the PATH..."
    if [[ "$OS" == "Darwin" ]]; then
        # macOS: Use VSCode command palette to install code command
        if [ -d "/Applications/Visual Studio Code.app" ]; then
            echo "Open Visual Studio Code and run 'Shell Command: Install 'code' command in PATH' from the Command Palette (Cmd+Shift+P)."
            echo "Then restart your terminal to make sure it's available."
        else
            echo "Visual Studio Code is not installed in the default location (/Applications). Please install it first."
        fi
    elif [[ "$OS" == "Linux" ]]; then
        # Linux: Check for common installation paths
        if [ -f "/usr/share/code/bin/code" ]; then
            echo "Adding /usr/share/code/bin to your PATH."
            export PATH="$PATH:/usr/share/code/bin"
        elif [ -f "/snap/bin/code" ]; then
            echo "Adding /snap/bin to your PATH."
            export PATH="$PATH:/snap/bin"
        else
            echo "Visual Studio Code CLI 'code' not found. Please ensure Visual Studio Code is installed."
        fi
    else
        echo "Unsupported operating system: $OS."
    fi
}

# Detect if 'code' command is available
if ! command -v code &> /dev/null; then
    echo "'code' command not found! Trying to add it to your PATH..."
    add_code_to_path
else
    echo "'code' command is already available."
fi

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
