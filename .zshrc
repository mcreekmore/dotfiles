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

# golang
if [[ ":$PATH:" != *":/usr/local/go/bin:"* ]]; then
    export PATH=$PATH:/usr/local/go/bin
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/matt/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/dotfiles/scripts:$PATH"
alias tms="$HOME/dotfiles/scripts/tmux-sessionizer.sh"
alias dlsc="$HOME/dotfiles/scripts/download-soundcloud.sh"
alias c="clear"

export PATH=$PATH:$(go env GOPATH)/bin

# solana
PATH="/home/matt/.local/share/solana/install/active_release/bin:$PATH"

# shell integration
eval "$(fzf --zsh)"

# ls colors
alias ls="ls --color=auto"

# keybinds
bindkey "^[[1;5C" forward-word # ctrl + right arrow 
bindkey "^[[1;5D" backward-word # ctrl + left arrow
