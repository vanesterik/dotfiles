# Set homebrew path
PATH=$PATH:/opt/homebrew/bin

# Autload zsh dependencies
autoload -U colors && colors
autoload -Uz compinit && compinit

# Set various aliases
alias vim=nvim
alias vi=nvim
alias ls="ls -als"

# Set starship prompt
eval "$(starship init zsh)"

# Set fnm environment (node version manager)
eval "$(fnm env --use-on-cd)"

# Initiate zsh Plugins
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
plug "agkozak/zsh-z"
plug "hlissner/zsh-autopair"
plug "koendirkvanesterik/zsh-git"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
