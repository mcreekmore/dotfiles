#!/usr/bin/env bash

set -euo pipefail

# update system
sudo pacman -Syu

# install yay (AUR helper), if not already present
if ! command -v yay >/dev/null 2>&1; then
  sudo pacman -S --needed base-devel git

  tmp_dir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
  (cd "$tmp_dir/yay" && makepkg -si)
  rm -rf "$tmp_dir"
else
  echo "yay is already installed."
fi
