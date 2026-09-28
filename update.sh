#!/usr/bin/env bash
#
# Regenerate the files that are snapshots of this Mac.
#
# Run it after installing or removing anything, and commit what changes.
set -euo pipefail

# Resolved from this script rather than from the working directory. It used to
# be $(pwd)/$(dirname "$0"), which is only correct when invoked as ./update.sh
# from inside the clone.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Homebrew --------------------------------------------------------------
brew bundle dump --no-vscode --describe --force --file "$DOTFILES/homebrew/Brewfile"
echo "homebrew/Brewfile"

# --- Ghostty's terminfo ----------------------------------------------------
#
# What setup.sh --ubuntu installs on a server. Ghostty sets TERM=xterm-ghostty
# and ships the description with the application, so a server has no way to
# learn it and the repository has to carry it across.
#
# Regenerated here rather than written once, so it tracks the installed Ghostty
# the same way the Brewfile tracks the installed packages.
if infocmp -x xterm-ghostty >/dev/null 2>&1; then
    mkdir -p "$DOTFILES/terminfo"
    infocmp -x xterm-ghostty > "$DOTFILES/terminfo/xterm-ghostty.terminfo"
    echo "terminfo/xterm-ghostty.terminfo"
else
    echo "terminfo/xterm-ghostty.terminfo -- skipped, Ghostty is not installed" >&2
fi
