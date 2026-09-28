# dotfiles

My personal dotfiles setup inspired by [@marcelbeumer](https://github.com/marcelbeumer), [@mhogeveen](https://github.com/mhogeveen) and [@tlolkema](https://github.com/tlolkema). Special thanks to you ... brothers in code :heart:

There are two setups here, and they are not the same size.

**macOS** — the full environment: every tool, every application, every font.

```zsh
> ./setup.sh
```

**Ubuntu** — a server, reached over SSH. The shell, the prompt and an editor,
and nothing with a window.

```zsh
> ./setup.sh --ubuntu
```

Either way, `--dry-run` prints what would happen and changes nothing, and
running the script again is safe: every step reports what is already there and
skips it.

After running the setup script, the environment will be configured with all
registered tools and configurations.

## Configurations

The following configurations are included in this dotfiles setup:

- [Zsh](https://www.zsh.org/) - A powerful shell that operates as an interactive shell and as a scripting language interpreter.
- [Homebrew](https://brew.sh/) - The package manager for macOS.

### Zsh

The setup script will configure Zsh based on the settings defined in the `zsh` folder. This includes various configurations and customizations to enhance your Zsh experience. All tools mentioned in this readme are configured to work seamlessly with Zsh.

This as Zsh is the default shell on macOS, it is recommended to use Zsh as your primary shell to take full advantage of the configurations and tools included in this dotfiles setup.

### Homebrew

The setup script will check if Homebrew is installed on your system. If it is not found, the script will automatically install Homebrew for you. This ensures that you have the necessary package manager to easily install and manage software on your macOS system.

In order to keep this dotfiles setup organized and maintainable, Homebrew packages are defined in a separate `Brewfile`. This file lists all the Homebrew packages that are registered. When you run the setup script, it will read the `Brewfile` and install all the listed packages automatically.

The `Brewfile` needs to be updated whenever Homebrew packages are added or removed from the setup. Update the `Brewfile` by running the command below:

```zsh
> ./update.sh
```

This command will align the `Brewfile` with the current state of Homebrew packages on your system. After an update, make sure to commit the changes to git.

## Tools

The following tools are included in this dotfiles setup:

- [Zap](https://www.zapzsh.com/) - A fast and minimal Zsh configuration framework.
- [Starship](https://starship.rs/) - The minimal, blazing-fast, and infinitely customizable prompt for any shell.
- [Ghostty](https://ghostty.org/) - A terminal emulator that uses platform-native UI and GPU acceleration.
- [Mise](https://mise.jdx.dev/) - A tool for managing and organizing your development environment.

All tools mentioned above are configured to work seamlessly with Zsh, ensuring a smooth and efficient development experience on your macOS system.

## Ubuntu

Servers get a deliberately smaller subset. Clone the repository and run the
script:

```zsh
> git clone https://github.com/vanesterik/dotfiles ~/.dotfiles
> ~/.dotfiles/setup.sh --ubuntu
```

It installs `zsh` and `vim` with apt, Starship and Zap from their own
installers, links `.zshrc`, `.vimrc` and `starship.toml` into place, and makes
Zsh the login shell. Then log out and back in — the shell it ran from is still
Bash, and Zap fetches the plugins on the first Zsh start.

**What it deliberately leaves out.** Homebrew, because it would pull half a
gigabyte and a compiler toolchain to install what apt already has. Mise and its
runtimes, because a project on a server brings its own — and two version
managers on one `PATH` is how a machine ends up with two Nodes. Ghostty's
configuration, because a terminal emulator has nothing to do over SSH.

### One `.zshrc`, two operating systems

There is no second Zsh configuration. `zsh/.zshrc` serves both, using two kinds
of guard:

- **On the tool**, for anything that depends on a binary being installed —
  `bat`, Starship, Mise, Zap. The same line is then correct on a laptop with
  everything and a server with almost nothing.
- **On the OS**, only for what genuinely differs: Homebrew's prefix,
  `JAVA_HOME`, the Android SDK, and the `lock`/`unlock` aliases, which call
  `caffeinate` and `pmset` and exist nowhere else.

Anything added to `.zshrc` that assumes a tool is present should be guarded the
first way. `alias cat=bat` was not, which breaks `cat` outright on a machine
without `bat`.
