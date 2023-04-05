#!/bin/bash

# Define dirname variable
dirname=$(pwd)/$(dirname "$0")

# Supress initial last login message
touch ~/.hushlogin

# Symlink .zshrc file
rm -f ~/.zshrc && ln -s $dirname/zsh/.zshrc ~/.zshrc

# Install zap
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)

# Install brew and various packages
which -s brew
if [[ $? != 0 ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update && brew upgrade && brew bundle --file $dirname/homebrew/Brewfile

# Create .config directory if it doesn't exist
[ ! -d ~/.config ] && mkdir ~/.config

# Symlink to various files and folders
rm -rf ~/.config/kitty && ln -s $dirname/kitty ~/.config/kitty
rm -rf ~/.config/nvim && ln -s $dirname/nvim ~/.config/nvim
