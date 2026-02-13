# @venables/dotfiles

```
█▀▀▄ █▀▀█ ▀▀█▀▀ █▀▀▀ ▀█▀ █░░░ █▀▀▀ █▀▀▀
█░░█ █░░█ ░░█░░ █▀▀░ ░█░ █░░░ █▀▀▀ ▀▀▀█
▀▀▀▀ ▀▀▀▀ ░░▀░░ ▀░░░ ▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀
```

## Principles

- Initial setup can be manual
- Always conform to the
  [XDG Base Directory Spec](https://specifications.freedesktop.org/basedir/latest/)
  like `$XDG_CONFIG_HOME` (`~/.config`) where possible.
- Keep local-specific configuration in `*.local` files that can be imported
  (e.g. `~/.ssh/config.local`)

## Getting started

1. Install XCode
1. `xcode-select --install`
1. `sudo xcodebuild -license accept`
1. Install Homebrew

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

## Installation

1. Clone the repo:

   ```sh
   git clone git@github.com:venables/dotfiles.git ~/.dotfiles
   ```

1. Bundle Homebrew packages:

   ```sh
   brew bundle --file=~/.dotfiles/homebrew/.Brewfile
   ```

1. Fix zsh compinit insecure directories warning:

   ```sh
   compaudit | xargs chmod go-w
   ```

1. Symlink dotfiles using [Stow](https://www.gnu.org/software/stow/):

   ```sh
   cd ~/.dotfiles
   stow \
    ai \
    formatters \
    ghostty \
    git \
    homebrew \
    hushlogin \
    mise \
    nvim \
    ssh \
    starship \
    tmux \
    tools \
    zed \
    zsh
   ```

   Once dotfiles have been `stow`ed, you can use the global bundle command for
   future updates:

   ```sh
   brew bundle --global
   ```

1. Install CLI tools

   [OpenCode](https://opencode.ai/)

   ```sh
   curl -fsSL https://opencode.ai/install | bash
   ```

   [Claude Code](https://claude.ai/)

   ```sh
   curl -fsSL https://claude.ai/install.sh | bash
   ```

   [Amp](https://opencode.ai/)

   ```sh
   curl -fsSL https://opencode.ai/install | bash
   ```

   [Droid](https://factory.ai/)

   ```sh
    curl -fsSL https://app.factory.ai/cli | sh
   ```

   [OpenClaw](https://openclaw.ai/)

   ```sh
   curl -fsSL https://openclaw.ai/install.sh | bash
   ```

   > NOTE: We install these directly (outside of homebrew) to better support
   > their auto-update features

## Configuration

### Shell (zsh)

1. Add homebrew `zsh` to `/etc/shells`

   ```sh
   sudo sh -c 'echo "$(brew --prefix)/bin/zsh" >> /etc/shells'
   ```

1. Use it as the default shell

   ```sh
   chsh -s $(brew --prefix)/bin/zsh
   ```

### SSH Keys

```sh
eval "$(ssh-agent -s)"
```

### Default

```sh
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -C "default"
```

```sh
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

```sh
ssh-copy-id -i ~/.ssh/id_ed25519.pub matt@host
```

### Github

I use separate keys per service. Not significantly better, but old habits.

```sh
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519_github -C "github"
```

```sh
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github
```

### GPG

```sh
mkdir -p ~/.gnupg
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
```

### Neovim / Lazyvim

A couple additions once lazyvim is running:

```
:MasonInstall oxlint
```

### GitHub CLI

Add the following Github CLI extensions:

```sh
gh ext install dlvhdr/gh-dash
gh ext install seachicken/gh-poi
gh ext install meiji163/gh-notify
```

## MacOS Settings

### Faster key repeat[^key-repeat]

```sh
defaults write -g InitialKeyRepeat -int 12
defaults write -g KeyRepeat -int 2
```

### Disable press and hold for special characters

```sh
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Show folders first in finder

```sh
defaults write com.apple.finder _FXSortFoldersFirst -bool true
```

After these, run `killall Finder`

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

Uncheck "Show Spotlight Search" in System Settings > Keyboard > Keyboard
Shortcuts > Spotlight

## Reference

[^key-repeat]: <https://mac-key-repeat.zaymon.dev>
