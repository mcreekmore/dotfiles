#!/bin/bash

OS_PATH=''
BREW_PATH=''
OS_NAME=$(uname -s)

if ! type "brew" > /dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -sfSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ "$OS_NAME" = "Darwin" ]; then
    OS_PATH='/usr/local/bin'
  elif [ "$OS_NAME" = "Linux" ]; then
    OS_PATH='/home/linuxbrew/.linuxbrew/bin'
  else
    echo "Unsupported perating system"
    exit 1
  fi
  BREW_PATH='$OS_PATH/brew'
else
  echo "Homebrew is already installed."
  OS_PATH=''
  BREW_PATH='brew'
fi

packages="chezmoi bitwarden-cli"

for pkg in $packages; do
  if ! $BREW_PATH list --versions "$pkg" >/dev/null 2>&1; then
    echo "Installing $pkg..."
    $BREW_PATH install "$pkg" --quiet
  else
    echo "$pkg is already installed."
  fi
done

echo "All packages are installed!"

# set zsh default shell
sudo chsh -s $(which zsh)

$OS_PATH/chezmoi init --apply https://github.com/mcreekmore/dotfiles.git

if [ "$STATUS" = "unauthenticated" ]; then
    echo "Bitwarden Master Password:"
    BW_SESSION=$($OS_PATH/bw login --raw </dev/tty)
    export BW_SESSION="$BW_SESSION"
    echo "Successfully logged in"
elif [ "$STATUS" = "locked" ]; then
    echo "Bitwarden vault is locked. Please enter your master password to unlock:"
    BW_SESSION=$($OS_PATH/bw unlock --raw </dev/tty)
    export BW_SESSION="$BW_SESSION"
    echo "Successfully unlocked vault"
else
    echo "Already logged into Bitwarden"
fi