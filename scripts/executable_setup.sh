#!/bin/bash

cd ~

# # zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# # zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

# starship
curl -sS https://starship.rs/install.sh | sh

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

if ! command_exists brew; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Define a list of Homebrew packages
packages=(
  chezmoi
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Loop over each package and install it if it's not already installed
for pkg in "${packages[@]}"; do
  if ! brew list --versions "$pkg" > /dev/null; then
    echo "Installing $pkg..."
    brew install "$pkg"
  else
    echo "$pkg is already installed."
  fi
done

echo "All packages are installed!"

# set zsh default shell
chsh -s $(which zsh)