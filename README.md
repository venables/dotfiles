# .dotfiles

My dotfiles

## Prereqs

These dotfiles used to contain new computer setup, but now they contain only the dotfiles (as well as a couple helpful git-specific binaries).

To install the required prereqs, you need to:

* Install [homebrew](https://brew.sh/)
* Install the following: `brew install asdf git vim zsh zsh-completions`

## Installation

```sh
git clone git@github.com:venables/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./init.sh
```

## Signing git commits

The gitconfig dotfile in this repo enables signed commits by default. To sign commits, see <https://samuelsson.dev/sign-git-commits-on-github-with-gpg-in-macos/>
