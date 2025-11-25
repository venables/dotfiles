# @venables/dotfiles

```
█▀▀▄ █▀▀█ ▀▀█▀▀ █▀▀▀ ▀█▀ █░░░ █▀▀▀ █▀▀▀
█░░█ █░░█ ░░█░░ █▀▀░ ░█░ █░░░ █▀▀▀ ▀▀▀█
▀▀▀▀ ▀▀▀▀ ░░▀░░ ▀░░░ ▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀
```

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
1. `sudo xcodebuild -license`
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

### Faster key repeat[^key-repeat]:

```sh
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
```

### Disable press and hold for special characters:

```
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Show hidden files in Finder:

```sh
defaults write -g AppleShowAllFiles -bool true
```

### Set up hot corners

```sh
# Top Left: Screen saver
defaults write com.appledock wvous-tl-corner -int 5
# Top right: Application Windows
defaults write com.appledock wvous-tr-corner -int 3
# Bottom Left: Mission Control
defaults write com.appledock wvous-bl-corner -int 2
# Bottom Right: Desktop
defaults write com.appledock wvous-br-corner -int 4
```

After setting these, restart the dock with `killall Dock`.

### Disable Spotlight keyboard shortcuts:

Uncheck "Show Spotlight Search" in System Settings > Keyboard > Keyboard Shortcuts > Spotlight

## Reference

[^1password-cli]: <https://developer.1password.com/docs/cli/get-started/>
[^key-repeat]: <https://mac-key-repeat.zaymon.dev>
