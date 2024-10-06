#!/usr/bin/env bash

# set hostname
hostnamectl set-hostname bluefin

# enable bluefin cli
# ujust bluefin-cli

# homebrew packages
brew install $(<brew_packages.txt)

# flatpak packages
flatpak install flathub --system -y $(<flatpak_packages.txt)

# setup dotfiles
if [ ! -d "$HOME/dotfiles" ]; then
    echo "Dotfiles repository not found. Cloning..."
    git clone https://github.com/mcreekmore/dotfiles.git ~/dotfiles
    cd ~/dotfiles || exit
    stow .
else
    echo "Dotfiles repository already exists."
fi

# setup nerd fonts
font="HackNerdFontMono-Regular.ttf"
if [ ! -f "$HOME/.local/share/fonts/$font" ]; then
    echo "Nerd font doesn't exist. Copying..."
    cp ~/dotfiles/fonts/$font ~/.local/share/fonts/
else
    echo "Nerd font already installed."
fi
# git clone --depth 100 https://github.com/ryanoasis/nerd-fonts.git
