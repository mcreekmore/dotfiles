# dotfiles

configuration managed by [GNU Stow](https://www.gnu.org/software/stow/)

## Requirements

- Git
- Stow
- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep)



## Installation

### OSX

```bash
brew install git
brew install stow
brew install ripgrep
brew install fzf
```

### Linux

```bash
apt install git stow fzf ripgrep
```

## Usage

Setup

```bash
git clone git@github.com:mcreekmore/.dotfiles.git
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd .dotfiles
stow .
```

Un-stow
```bash
cd .dotfiles
stow -D .
```
