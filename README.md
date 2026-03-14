# dotfiles

My personal dotfiles setup inspired by [@marcelbeumer](https://github.com/marcelbeumer), [@mhogeveen](https://github.com/mhogeveen) and [@tlolkema](https://github.com/tlolkema). Special thanks to you ... brothers in code :heart:

> **⚠️ This dotfiles setup is intended for macOS (OSX) users. Compatibility with other operating systems is not supported.**

Start by running command below:

```zsh
> ./setup.sh
```

After running the setup script, the environment will be configured with all registered tools and configurations.

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