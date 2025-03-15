#!/usr/bin/env bash

# update system
sudo pacman -Syu

# install yay
tmp_dir = arch_setup_tmp_dir
mkdir $tmp_dir
cd $tmp_dir
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ../../
rm -rf $tmp_dir
