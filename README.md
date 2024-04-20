# dotfiles

configuration managed by [GNU Stow](https://www.gnu.org/software/stow/)

## Requirements

- Git
- Stow

## Installation

### OSX

```bash
brew install git
brew install stow
```

### Linux

```bash
apt install git stow
```

## Usage

```bash
git clone git@github.com:mcreekmore/dotfiles.git
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd dotfiles
stow .
```
