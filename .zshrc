# uncomment this line and the bottom "zprof" to enable zsh profiling
# zmodload zsh/zprof

# set nvim (if it exists) as default editor
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=$(command -v nvim)
else
  export EDITOR=$(command -v vim)
fi

# homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# autosuggestions
if [[ $(uname) == "Darwin" ]]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# syntax highlighting
if [[ $(uname) == "Darwin" ]]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# tmux powerline theme
TMUX_POWERLINE_THEME='catppuccin'

# zoxide
export PATH="$HOME/.local/bin:$PATH"
if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# golang
if [[ ":$PATH:" != *":/usr/local/go/bin:"* ]]; then
    export PATH=$PATH:/usr/local/go/bin
fi

# nvm
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# pnpm
export PNPM_HOME="/home/matt/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# default browser for wsl
if uname -r |grep -q 'microsoft' ; then
    export BROWSER='/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe'
fi

# solana
PATH="/home/matt/.local/share/solana/install/active_release/bin:$PATH"

# shell integration
eval "$(fzf --zsh)"

# ls colors
alias ls="ls --color=auto"

# keybinds
bindkey "^[[1;5C" forward-word # ctrl + right arrow 
bindkey "^[[1;5D" backward-word # ctrl + left arrow

path+=("$HOME/dotfiles/scripts")
export PATH
# export PATH="$HOME/dotfiles/scripts:$PATH"
alias tms="$HOME/dotfiles/scripts/tmux-sessionizer.sh"
alias zs="$HOME/dotfiles/scripts/zellij-smart-sessionizer.sh"
# ctrl + f
bindkey -s ^f "zellij-smart-sessionizer.sh^M"
alias zms="$HOME/dotfiles/scripts/zellij-sessionizer.sh ~/code ~/.config"
alias dlsc="$HOME/dotfiles/scripts/download-soundcloud.sh"
alias c="clear"
alias k="kubectl"
alias h="helm"
alias t="tofu"

# zprof


