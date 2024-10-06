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
fi

# setup nerd fonts
font="HackNerdFontMono-Regular.ttf"
if [ ! -f "$HOME/.local/share/fonts/$font" ]; then
    echo "Nerd font doesn't exist. Copying..."
    cp ~/dotfiles/fonts/$font ~/.local/share/fonts/
fi

# setup tpm
if [ ! -f "$HOME/.config/tmux/plugin/tpm" ]; then
    echo "Setting up tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    ~/.config/tmux/plugins/tpm/bin/install_plugins
fi
