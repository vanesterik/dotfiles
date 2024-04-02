#!/bin/bash

# Define dirname variable
dirname=$(pwd)/$(dirname "$0")

# Supress initial last login message
touch ~/.hushlogin

# Symlink .zshrc file
rm -f ~/.zshrc && ln -s "$dirname/zsh/.zshrc" ~/.zshrc

# Install zap
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)

# Install brew and various packages
which -s brew
if [[ $? != 0 ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update && brew upgrade && brew bundle --file "$dirname/homebrew/Brewfile"

# Create .config directory if it doesn't exist
[ ! -d ~/.config ] && mkdir ~/.config

# Symlink to various files and folders
rm -f ~/.config/starship.toml && ln -s "$dirname/starship/starship.toml" ~/.config/starship.toml
rm -rf ~/.config/kitty && ln -s "$dirname/kitty" ~/.config/kitty

# Set dock to instant autohide
defaults write com.apple.dock autohide -bool true && defaults write com.apple.dock autohide-delay -float 0 && defaults write com.apple.dock autohide-time-modifier -float 0 && killall Dock
