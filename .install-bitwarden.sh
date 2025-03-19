#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type bw >/dev/null 2>&1 && exit

# Check for Windows first
if [ -n "$WINDIR" ] || [ -n "$SystemRoot" ] || [ "$OS" = "Windows_NT" ]; then
    echo "Installing password manager on Windows..."
    exit 0
fi

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing Homebrew first..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# For Unix-like systems
case "$(uname -s)" in
Darwin)
    echo "Installing Bitwarden on macOS..."
    brew install bitwarden-cli
    ;;
Linux)
    echo "Installing Bitwarden on Linux..."
    brew install bitwarden-cli
    ;;
*)
    echo "unsupported OS"
    exit 1
    ;;
esac