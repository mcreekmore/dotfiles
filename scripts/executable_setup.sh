#!/bin/bash

if ! command_exists brew; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -sfSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

packages="chezmoi bitwarden-cli"

for pkg in $packages; do
  if ! brew list --versions "$pkg" >/dev/null 2>&1; then
    echo "Installing $pkg..."
    brew install "$pkg" --quiet
  else
    echo "$pkg is already installed."
  fi
done

echo "All packages are installed!"

# set zsh default shell
# sudo chsh -s $(which zsh)

chezmoi init --apply https://github.com/mcreekmore/dotfiles.git

echo "Bitwarden Master Password:"
bw config server https://vault.creekmore.io
BW_SESSION=$(bw login --raw </dev/tty)
export BW_SESSION="$BW_SESSION"
bw sync