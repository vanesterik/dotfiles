#!/usr/bin/env zsh

while [[ $(brew list | wc -l) -ne 0 ]]; do
  for PACKAGE in $(brew list); do
    brew uninstall --force --ignore-dependencies $PACKAGE
  done
done
