# dotfiles

configuration managed by [chezmoi](https://www.chezmoi.io/)
<!-- configuration managed by [GNU Stow](https://www.gnu.org/software/stow/) -->

## Requirements

- Git
- [chezmoi](https://github.com/twpayne/chezmoi)


## Installation

### OSX

```bash
brew install git stow ripgrep fzf chezmoi
```

### Linux

```bash
apt install git zsh stow fzf ripgrep
```

## Usage

Setup

```bash
chezmoi init --apply --verbose https://github.com/mcreekmore/dotfiles.git
# ./dotfiles/scripts/setup.sh
```

<!-- Un-stow
```bash
cd dotfiles
stow -D .
``` -->
