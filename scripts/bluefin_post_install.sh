#!/usr/bin/env bash

# set hostname
hostnamectl set-hostname bluefin

# enable bluefin cli
# ujust bluefin-cli

# homebrew packages
brew install $(<brew_packages.txt)
# brew install stow
# brew install neovim
# brew isntall zellij
# brew install npm

# flatpak packages
flatpak install flathub --system -y $(<flatpak_packages.txt)
# flatpak install flathub -y com.valvesoftware.Steam
# flatpak install flathub -y com.spotify.Client
# flatpak install flathub -y org.telegram.desktop
# flatpak install flathub -y com.discordapp.Discord
# flatpak install flathub -y org.signal.Signal
# flatpak install flathub -y org.videolan.VLC
# flatpak install flathub -y com.obsproject.Studio # OBS
# flatpak install flathub -y md.obsidian.Obsidian
# flatpak install flathub -y chat.simplex.simplex 
# flatpak install flathub -y org.keepassxc.KeePassXC # KeePassXC
# flatpak install flathub -y im.riot.Riot # Element
# flatpak install flathub -y org.audacityteam.Audacity
# flatpak install flathub -y com.adamcake.Bolt
# flatpak install flathub -y net.runelite.RuneLite
# flatpak install flathub -y org.gnome.Boxes
# flatpak install flathub -y tv.plex.PlexDesktop
# flatpak install flathub -y org.gnome.Connections

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
if [ ! -f "$HOME/.local/share/fonts/HackNerdFontMono-Regular.ttf" ]; then
    echo "Nerd font doesn't exist. Copying..."
    mv ~/dotfiles/fonts/HackNerdFontMono-Regular.ttf ~/.local/share/fonts/
else
    echo "Nerd font already installed."
fi
# git clone --depth 100 https://github.com/ryanoasis/nerd-fonts.git
