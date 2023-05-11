# Set homebrew path
PATH=$PATH:/opt/homebrew/bin

# Autload zsh dependencies
autoload -U colors && colors
autoload -Uz compinit && compinit

# Source various files
source $HOME/.secrets

# Set various aliases
alias vim=nvim
alias vi=nvim
alias ls="ls -als"
alias cat=bat

# Set starship prompt
eval "$(starship init zsh)"

# Set fnm environment (node version manager)
eval "$(fnm env --use-on-cd)"

# Initiate zsh plugins
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
plug "agkozak/zsh-z"
plug "hlissner/zsh-autopair"
plug "vanesterik/zsh-git-alias"
plug "vanesterik/zsh-openai-prompts"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"

# Settings for zsh history substring plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=false
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=false
