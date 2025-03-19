#!/bin/bash

# starship
curl -sS https://starship.rs/install.sh | sh

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# # zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# # zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

if ! command_exists brew; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Define a list of Homebrew packages as a space-separated string
packages="chezmoi zsh-autosuggestions zsh-syntax-highlighting bitwarden-cli"

# Loop over each package and install it if it's not already installed
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
sudo chsh -s $(which zsh)

# set up dotfiles
chezmoi init --apply https://github.com/mcreekmore/dotfiles.git

# set up bitwarden
bw config server https://vault.creekmore.io
echo "Bitwarden Master Password:"
export BW_SESSION=$(bw login --raw)
bw sync
