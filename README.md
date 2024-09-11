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
git clone git@github.com:mcreekmore/dotfiles.git
# tmux package manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
# oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# starship
curl -sS https://starship.rs/install.sh | sh
# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
cd dotfiles
stow .
```

Un-stow
```bash
cd dotfiles
stow -D .
```
