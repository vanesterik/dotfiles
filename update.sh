#!/bin/bash

# Define dirname variable
dirname=$(pwd)/$(dirname "$0")

# Generate Brewfile based on currently installed Homebrew packages
brew bundle dump --no-vscode --describe --force --file "$dirname/homebrew/Brewfile"