#!/usr/bin/env bash
#
# Set up a machine.
#
#   ./setup.sh              the Mac: every tool, every application, every font
#   ./setup.sh --ubuntu     a server: the shell, the prompt, an editor
#   ./setup.sh --dry-run    print what would happen, change nothing
#
# One file rather than two, because the two halves share their shape -- the
# same symlinks, the same zap, the same prompt -- and only differ in how
# packages arrive and how much of the machine there is to set up.
set -euo pipefail

TARGET=""
DRY_RUN=0

usage() {
    sed -n '3,8p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

for argument in "$@"; do
    case "$argument" in
        --ubuntu)    TARGET=ubuntu ;;
        --dry-run)   DRY_RUN=1 ;;
        -h|--help)   usage; exit 0 ;;
        *) echo "Unknown argument: $argument" >&2; usage >&2; exit 2 ;;
    esac
done

# --- Shared ----------------------------------------------------------------

section() { printf '\n== %s\n' "$1"; }
note()    { printf '   %s\n' "$1"; }
run() {
    if [ "$DRY_RUN" = 1 ]; then
        printf '   would run: %s\n' "$*"
    else
        "$@"
    fi
}

FAILED=0
check() {
    if eval "$2" >/dev/null 2>&1; then
        printf '   ok      %s\n' "$1"
    else
        printf '   FAILED  %s -- %s\n' "$1" "$3"
        FAILED=1
    fi
}

refuse_if_failed() {
    if [ "$FAILED" = 1 ] && [ "$DRY_RUN" = 0 ]; then
        echo >&2
        echo "Refusing to continue. Nothing has been installed." >&2
        exit 1
    fi
}

# rm before ln, because `ln -s` onto an existing symlink to a directory creates
# a link *inside* the directory rather than replacing it.
link() {
    run rm -rf "$2"
    run ln -s "$1" "$2"
    note "$2 -> $1"
}

# The clone, resolved from this script rather than from the working directory.
# It used to be $(pwd)/$(dirname "$0"), which is only correct when the script is
# invoked as ./setup.sh from inside the clone: run as ~/.dotfiles/setup.sh from
# anywhere else, $0 is already absolute and prefixing the working directory
# produces a path that does not exist. It is also where the `/./` in the
# existing symlinks came from.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Zap, which both halves install the same way.
#
# --keep matters: without it zap moves ~/.zshrc aside and writes its own from a
# template, and once ~/.zshrc is a symlink into this repository that is zap
# replacing the link. It also has to run *after* the symlinks, because its last
# line is
#
#     [[ $? -eq 0 ]] && source "${ZDOTDIR:-$HOME}/.zshrc"
#
# which fails outright when there is no ~/.zshrc yet.
#
# That same line means its exit status is really the status of the last line of
# .zshrc, and says nothing about whether zap installed -- so this judges it by
# what it left on disk instead.
install_zap() {
    section "Zap"
    if [ -d "$HOME/.local/share/zap" ]; then
        note "already installed at ~/.local/share/zap"
        return
    fi
    if [ "$DRY_RUN" = 1 ]; then
        note "would install zap into ~/.local/share/zap"
        return
    fi

    local installer
    installer="$(mktemp)"
    curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh -o "$installer"
    zsh "$installer" --keep || true
    rm -f "$installer"

    if [ ! -d "$HOME/.local/share/zap" ]; then
        echo "   zap did not install. The output above says why." >&2
        exit 1
    fi
}

# --- macOS -----------------------------------------------------------------

setup_macos() {
    section "Preflight"
    check "macOS" '[ "$(uname -s)" = Darwin ]' \
          "this half installs with Homebrew; pass --ubuntu for a server"
    check "curl"  'command -v curl' \
          "needed to fetch the Homebrew and zap installers"
    refuse_if_failed

    # Suppress the last-login banner.
    run touch "$HOME/.hushlogin"

    section "Homebrew"
    # `command -v` rather than `which -s` followed by a $? test: the old form
    # aborts under `set -e` on the very machine it is testing for.
    if command -v brew >/dev/null 2>&1; then
        note "already installed at $(command -v brew)"
    elif [ "$DRY_RUN" = 1 ]; then
        note "would install Homebrew"
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    section "Packages"
    run brew update
    run brew upgrade
    run brew bundle --file "$DOTFILES/homebrew/Brewfile"

    section "Symlinks"
    # mkdir -p rather than `[ ! -d ~/.config ] && mkdir ~/.config`, which
    # returns non-zero when the directory already exists and therefore aborts
    # under `set -e` on every machine after the first run.
    run mkdir -p "$HOME/.config"

    link "$DOTFILES/zsh/.zshrc"             "$HOME/.zshrc"
    link "$DOTFILES/vim/.vimrc"             "$HOME/.vimrc"
    link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
    link "$DOTFILES/ghostty"                "$HOME/.config/ghostty"
    link "$DOTFILES/mise"                   "$HOME/.config/mise"

    install_zap

    section "Dock"
    # Instant autohide.
    run defaults write com.apple.dock autohide -bool true
    run defaults write com.apple.dock autohide-delay -float 0
    run defaults write com.apple.dock autohide-time-modifier -float 0
    run killall Dock || true
}

# --- Ubuntu ----------------------------------------------------------------
#
# Deliberately smaller. A server needs the shell, the prompt and an editor; it
# does not need a browser, a password manager or a font. Homebrew is absent
# because it would pull half a gigabyte and a compiler toolchain to install
# what apt already has, and mise because a project on a server brings its own
# runtimes -- two version managers on one PATH is how a machine ends up with
# two Nodes.
#
# ghostty/ and mise/ are not linked here for the same reasons: a terminal
# emulator's configuration means nothing over SSH, and mise is not installed.

setup_ubuntu() {
    section "Preflight"
    check "Ubuntu" '[ -r /etc/os-release ] && grep -qi ubuntu /etc/os-release' \
          "this half installs with apt and changes the login shell"
    # Availability only. `sudo -v` here would prompt with its output redirected
    # into the check, so the prompt would be invisible and this would look hung.
    check "sudo"   'command -v sudo' \
          "needed for apt, for starship's installer and to change the login shell"
    check "curl"   'command -v curl' \
          "needed to fetch the starship and zap installers"
    refuse_if_failed

    # Not a failure. Every symlink is computed from this script's own location,
    # so a clone anywhere works -- except .zshrc's last line, which looks for
    # secrets at a fixed path because a shell startup file cannot know where the
    # repository went.
    if [ "$DOTFILES" != "$HOME/.dotfiles" ]; then
        note "note    this clone is at $DOTFILES, not ~/.dotfiles"
        note "        everything works; only zsh/.secrets is looked for at the latter"
    fi

    section "Packages"
    if dpkg -s zsh vim >/dev/null 2>&1; then
        note "zsh and vim already installed"
    else
        run sudo apt-get update
        run sudo apt-get install -y zsh vim
    fi

    section "Terminfo"
    # Ghostty sets TERM=xterm-ghostty, and that description ships with Ghostty
    # -- on the Mac. A server has never seen it, so ncurses falls back to
    # something minimal and the escape sequences zsh emits to move the cursor
    # are wrong. It shows up while typing rather than as an error: `ls -als`
    # renders as `ls--aalls`, because zsh-syntax-highlighting redraws the whole
    # line on every keystroke against a cursor position the terminal does not
    # agree with.
    #
    # The description is carried in this repository rather than fetched,
    # because this half runs on the server, where Ghostty is not installed.
    # update.sh regenerates it from the Mac's copy, the way it regenerates the
    # Brewfile.
    #
    # ~/.terminfo, which ncurses reads by default, so this needs no sudo. tic
    # is part of ncurses-bin and is already on a bare Ubuntu image.
    if [ ! -f "$DOTFILES/terminfo/xterm-ghostty.terminfo" ]; then
        note "no terminfo/xterm-ghostty.terminfo in this clone; skipped"
    elif infocmp xterm-ghostty >/dev/null 2>&1; then
        note "xterm-ghostty already known to this machine"
    elif [ "$DRY_RUN" = 1 ]; then
        note "would install xterm-ghostty into ~/.terminfo"
    else
        # tic warns that "older tic versions may treat the description field as
        # an alias", about a line Ghostty wrote and nothing here can act on.
        # Kept for a real failure, dropped otherwise -- as the starship step
        # does with its own wall of output.
        local ticlog
        ticlog="$(mktemp)"
        if tic -x -o "$HOME/.terminfo" "$DOTFILES/terminfo/xterm-ghostty.terminfo" >"$ticlog" 2>&1; then
            note "xterm-ghostty installed into ~/.terminfo"
        else
            cat "$ticlog" >&2
            rm -f "$ticlog"
            exit 1
        fi
        rm -f "$ticlog"
    fi

    section "Starship"
    # From its own installer rather than apt: Ubuntu's archive does not carry
    # it, and the installer resolves the right binary for the architecture.
    if command -v starship >/dev/null 2>&1; then
        note "already installed at $(command -v starship)"
    elif [ "$DRY_RUN" = 1 ]; then
        note "would install starship into /usr/local/bin"
    else
        local installer log
        installer="$(mktemp)"
        log="$(mktemp)"
        curl -fsSL https://starship.rs/install.sh -o "$installer"
        # Its output is a page of "add this to your rc file" for a dozen
        # shells, none of which applies -- .zshrc already does it. Shown only
        # on failure.
        if sudo sh "$installer" --yes --bin-dir /usr/local/bin >"$log" 2>&1; then
            note "installed $(starship --version | head -1)"
        else
            cat "$log" >&2
            rm -f "$installer" "$log"
            exit 1
        fi
        rm -f "$installer" "$log"
    fi

    section "Symlinks"
    run mkdir -p "$HOME/.config"
    link "$DOTFILES/zsh/.zshrc"             "$HOME/.zshrc"
    link "$DOTFILES/vim/.vimrc"             "$HOME/.vimrc"
    link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"

    install_zap
    # Zap reports a plugin it could not fetch as it goes, so a network problem
    # names the plugin here rather than appearing as a missing alias later.

    section "Login shell"
    local zsh_path target_user current_shell
    zsh_path="$(command -v zsh || echo /usr/bin/zsh)"
    # `id -un` rather than $USER: the variable is not set in every context -- a
    # non-login shell, a cron job -- and under `set -u` an unset one aborts
    # here, after everything else has already been installed.
    target_user="$(id -un)"
    # The account's login shell, from the passwd database. $SHELL is the shell
    # currently running, which is still bash immediately after chsh -- so
    # reading it would re-run chsh forever and never report this as done.
    current_shell="$(getent passwd "$target_user" | cut -d: -f7)"

    if [ "$current_shell" = "$zsh_path" ]; then
        note "already $zsh_path for $target_user"
    else
        # Through sudo: a bare `chsh` asks for the account password, which a
        # key-only server login does not have to hand.
        run sudo chsh -s "$zsh_path" "$target_user"
        note "set to $zsh_path for $target_user"
    fi

    run touch "$HOME/.hushlogin"
}

# --- Which half ------------------------------------------------------------
#
# --ubuntu is explicit rather than detected, but a Mac setup attempted on Linux
# would fail deep inside Homebrew rather than saying so -- hence the nudge.
if [ -z "$TARGET" ] && [ "$(uname -s)" = "Linux" ]; then
    echo "This machine is Linux. Run ./setup.sh --ubuntu" >&2
    exit 2
fi

case "${TARGET:-macos}" in
    ubuntu) setup_ubuntu ;;
    macos)  setup_macos ;;
esac

if [ "$DRY_RUN" = 0 ] && [ "${TARGET:-macos}" = ubuntu ]; then
    printf '\nDone. Log out and back in: the shell you ran this from is still bash.\n'
fi
