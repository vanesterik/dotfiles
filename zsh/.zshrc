# Set homebrew path
PATH=$PATH:/opt/homebrew/bin

# Autload zsh dependencies
autoload -U colors && colors
autoload -Uz compinit && compinit

# Set various aliases
alias ls="ls -als"
alias cat=bat
alias lock="caffeinate -dimsu & pmset displaysleepnow"
alias unlock="pkill caffeinate"
alias activate="source .venv/bin/activate"

# Set starship prompt
eval "$(starship init zsh)"

# Initiate zsh plugins
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
plug "agkozak/zsh-z"
plug "hlissner/zsh-autopair"
plug "vanesterik/zsh-git-alias"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
plug "vanesterik/zsh-venv-auto-switch"

# Settings for zsh history substring plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=false
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=false

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

# Set local bin path for user installed binaries
export PATH="$PATH:/Users/koendirkvanesterik/.local/bin"

# Set mise-en-place environment manager
eval "$(mise activate zsh)"

export PATH=$PATH:/Users/koendirkvanesterik/bin

# The next line updates PATH for Nebius CLI.
if [ -f '/Users/koendirkvanesterik/.nebius/path.zsh.inc' ]; then source '/Users/koendirkvanesterik/.nebius/path.zsh.inc'; fi

# Specifc project aliases
alias start_cpu="nebius compute instance start --id computeinstance-e00m845e2e47qjar4n"
alias start_gpu="nebius compute instance start --id computeinstance-e00ybgs6dycc8q1nea"
alias stop_cpu="nebius compute instance stop --id computeinstance-e00m845e2e47qjar4n"
alias stop_gpu="nebius compute instance stop --id computeinstance-e00ybgs6dycc8q1nea"
