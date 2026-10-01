# One .zshrc for macOS and Ubuntu.
#
# Two kinds of guard, and the difference matters. Anything that depends on a
# *tool* is guarded on whether that tool is there, so the same line is correct
# on a laptop with everything and a server with almost nothing. Only what
# depends on the *platform* -- Homebrew's prefix, pmset, the Android SDK -- is
# guarded on the OS.

# Autoload zsh dependencies
autoload -U colors && colors

# --- Completion ------------------------------------------------------------
#
# Before the plugins, and that ordering is load-bearing: compinit is what
# defines `compdef`, and zsh-git-alias calls it ten times at load. Started
# after them and every one of those calls is a "command not found".
#
# fpath first so this single call sees ~/.zfunc. It used to run twice, once
# here and once after fpath -- which worked, and cost a second scan of the
# completion dump on every shell start.
fpath+=~/.zfunc
autoload -Uz compinit && compinit
# Set zsh menu selection for completion using arrow keys
zstyle ':completion:*' menu select

# Set various aliases
alias ls="ls -als"
alias activate="source .venv/bin/activate"

# --- Tools, each guarded on its own presence -------------------------------
#
# `alias cat=bat` was unguarded, which is fine on a machine that has bat and
# breaks cat outright on one that does not.
command -v bat >/dev/null && alias cat=bat

# Set starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# Set mise-en-place environment manager
command -v mise >/dev/null && eval "$(mise activate zsh)"

# Initiate zsh plugins
if [ -f "$HOME/.local/share/zap/zap.zsh" ]; then
  source "$HOME/.local/share/zap/zap.zsh"
  plug "agkozak/zsh-z"
  plug "hlissner/zsh-autopair"
  plug "vanesterik/zsh-git-alias"
  plug "zsh-users/zsh-autosuggestions"
  plug "zsh-users/zsh-syntax-highlighting"
  plug "zsh-users/zsh-history-substring-search"
  plug "vanesterik/zsh-venv-auto-switch"
fi

# Settings for zsh history substring plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=false
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=false

# --- macOS only ------------------------------------------------------------
#
# Homebrew's prefix, the JVM, the Android SDK and the two screen-lock aliases.
# caffeinate and pmset do not exist off macOS, so these are the lines that
# have to know what they are running on.
if [[ "$OSTYPE" == darwin* ]]; then
  alias lock="caffeinate -dimsu & pmset displaysleepnow"
  alias unlock="pkill caffeinate"

  export HOMEBREW_NO_ENV_HINTS=1
  eval "$(/opt/homebrew/bin/brew shellenv)"

  export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
  export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
  export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
  export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
fi

# --- Paths -----------------------------------------------------------------
#
# $HOME rather than a spelled-out home directory. These named
# /Users/koendirkvanesterik, which is not this machine's home, so both entries
# had been pointing at nothing.
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/bin"
