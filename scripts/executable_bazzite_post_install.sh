#!/usr/bin/env bash

# set hostname
hostnamectl set-hostname bazzite

# enable bluefin cli
# ujust bluefin-cli

# homebrew packages
brew install $(<brew_packages.txt)

# flatpak packages
flatpak install flathub --system -y $(<flatpak_packages.txt)

# setup nerd fonts
font="HackNerdFontMono-Regular.ttf"
if [ ! -f "$HOME/.local/share/fonts/$font" ]; then
    echo "Nerd font doesn't exist. Copying..."
    cp ~/.local/share/chezmoi/fonts/$font ~/.local/share/fonts/
fi

# setup tpm
if [ ! -f "$HOME/.config/tmux/plugin/tpm" ]; then
    echo "Setting up tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    ~/.config/tmux/plugins/tpm/bin/install_plugins
    mkdir -p ~/.config/tmux/plugins/catppuccin
    git clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
fi
