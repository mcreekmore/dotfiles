# uncomment this line and the bottom "zprof" to enable zsh profiling
# zmodload zsh/zprof

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

# zoxide
export PATH="$HOME/.local/bin:$PATH"
eval "$(zoxide init zsh)"

# golang
if [[ ":$PATH:" != *":/usr/local/go/bin:"* ]]; then
    export PATH=$PATH:/usr/local/go/bin
fi

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

# zprof
