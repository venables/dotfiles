# @venables/dotfiles

```
█▀▀▄ █▀▀█ ▀▀█▀▀ █▀▀▀ ▀█▀ █░░░ █▀▀▀ █▀▀▀
█░░█ █░░█ ░░█░░ █▀▀░ ░█░ █░░░ █▀▀▀ ▀▀▀█
▀▀▀▀ ▀▀▀▀ ░░▀░░ ▀░░░ ▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀
```

## Key Tools & Commands

| Command  | Tool                                                     | Description                                           |
| -------- | -------------------------------------------------------- | ----------------------------------------------------- |
| `cat`    | [bat](https://github.com/sharkdp/bat)                    | `cat` with syntax highlighting.                       |
| `Ctrl+r` | [atuin](https://github.com/atuinsh/atuin)                | Magical shell history search (syncs across machines). |
| `cc`     | [claude code](https://github.com/anthropics/claude-code) | Claude Code CLI                                       |
| `cd`     | [zoxide](https://github.com/ajeetdsouza/zoxide)          | Smarter `cd` that remembers where you go.             |
| `g`      | [git](https://github.com/git/git)                        | Git wrapper with many aliases (see `aliases.zsh`).    |
| `gg`     | [lazygit](https://github.com/jesseduffield/lazygit)      | Git TUI.                                              |
| `ls`     | [eza](https://github.com/eza-community/eza)              | Modern `ls` with icons and colors.                    |
| `n`      | [nvim](https://github.com/neovim/neovim)                 | Opens neovim in current directory if non specified    |
| `oc`     | [opencode](https://github.com/sst/opencode)              | Opencode CLI                                          |
| `tldr`   | [tldr](https://github.com/tldr-pages/tldr)               | Simplified man pages (e.g. `tldr tar`).               |
| `y`      | [yazi](https://github.com/sxyazi/yazi)                   | Terminal file manager (vim-like). Exits to directory. |

## Usage

All dotfiles are managed via [Stow](https://www.gnu.org/software/stow/)

```sh
stow \
    git \
    gnupg \
    homebrew \
    hushlogin \
    mise \
    nvim \
    ssh \
    starship \
    zsh
```

## Getting started

1. Install XCode
1. `xcode-select --install`
1. `sudo xcodebuild -license accept`
1. Install Homebrew

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

## Installing the dotfiles

1. Clone the repo:

   ```sh
   git clone git@github.com:venables/dotfiles.git ~/.dotfiles
   ```

1. Bundle

   ```sh
   brew bundle --file=~/.dotfiles/homebrew/.Brewfile
   ```

   Once dotfiles have been `stow`ed, you can use

   ```sh
   brew bundle --global
   ```

### Shell (zsh)

1. Add homebrew `zsh` to `/etc/shells`

   ```sh
   sudo sh -c 'echo "$(brew --prefix)/bin/zsh" >> /etc/shells'
   ```

1. Use it as the default shell

   ```sh
   chsh -s $(brew --prefix)/bin/zsh
   ```

## GitHub CLI

Add the following Github CLI extensions:

```sh
gh ext install dlvhdr/gh-dash
gh ext install seachicken/gh-poi
```

## SSH Keys

```
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519_github -C "github"
```

```
eval "$(ssh-agent -s)"
```

```
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github
```

## MacOS Settings

### Faster key repeat[^key-repeat]

```sh
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
```

### Disable press and hold for special characters

```
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Show hidden files in Finder

```sh
defaults write -g AppleShowAllFiles -bool true
```

### Set up hot corners

| Corner       | Action                |
| ------------ | --------------------- |
| Top Left     | Screen Saver (Locked) |
| Top Right    | Application Windows   |
| Bottom Left  | Mission Control       |
| Bottom Right | Desktop               |

Set the hot corners

```sh
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tr-corner -int 3
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-br-corner -int 4
killall Dock
```

Lock the computer after 5s

```sh
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5
killall SystemUIServer
```

Disable some auto changes

```sh
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
```

### Disable Spotlight keyboard shortcuts

Uncheck "Show Spotlight Search" in System Settings > Keyboard > Keyboard Shortcuts > Spotlight

## Reference

[^key-repeat]: <https://mac-key-repeat.zaymon.dev>
