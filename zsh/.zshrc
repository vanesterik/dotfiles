# Set homebrew path
PATH=$PATH:/opt/homebrew/bin

# Autload zsh dependencies
autoload -U colors && colors
autoload -Uz compinit && compinit

# Set various aliases
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
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"

# Settings for zsh history substring plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=false
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=false

# Settings for pyenv (python version manager)
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Settings for Homebrew
export HOMEBREW_NO_ENV_HINTS=1
eval "$(/opt/homebrew/bin/brew shellenv)"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# Add .zfunc directory to fpath environment variable and initialize zsh completion system
fpath+=~/.zfunc; autoload -Uz compinit; compinit
# Set zsh menu selection for completion using arrow keys
zstyle ':completion:*' menu select
