# @venables/dotfiles

```
█▀▀▄ █▀▀█ ▀▀█▀▀ █▀▀▀ ▀█▀ █░░░ █▀▀▀ █▀▀▀
█░░█ █░░█ ░░█░░ █▀▀░ ░█░ █░░░ █▀▀▀ ▀▀▀█
▀▀▀▀ ▀▀▀▀ ░░▀░░ ▀░░░ ▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀
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

### Disable Spotlight keyboard shortcuts:

Uncheck "Show Spotlight Search" in System Settings > Keyboard > Keyboard Shortcuts > Spotlight

## Reference

[^1password-cli]: <https://developer.1password.com/docs/cli/get-started/>
[^key-repeat]: <https://mac-key-repeat.zaymon.dev>
