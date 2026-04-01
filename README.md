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

1. Install Xcode and command line tools:

   ```sh
   xcode-select --install
   sudo xcodebuild -license accept
   ```

1. Clone the repo:

   ```sh
   git clone git@github.com:venables/dotfiles.git ~/.dotfiles
   ```

1. Run the setup script:

   ```sh
   cd ~/.dotfiles
   ./setup
   ```

   This idempotent script handles:
   - Installing Homebrew (if missing)
   - Bundling Homebrew packages from `.Brewfile`
   - Symlinking dotfiles via [Stow](https://www.gnu.org/software/stow/)
   - Fixing zsh compinit permissions
   - Setting Homebrew zsh as the default shell
   - Installing mise runtimes (node, python, ruby, rust, etc.)
   - Installing/updating CLI tools (Claude Code, OpenCode, Amp, Droid, OpenClaw)
   - Installing/updating global npm packages
   - Configuring GPG with pinentry-mac
   - Installing/upgrading GitHub CLI extensions

   To also apply macOS system preferences (key repeat, hot corners, Finder,
   etc.), pass the `--macos` flag:

   ```sh
   ./setup --macos
   ```

   Re-running `./setup` at any time is safe -- it converges the machine onto the
   latest desired state, updating CLI tools, npm packages, and gh extensions to
   their latest versions.

## Manual Configuration

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

### Neovim / Lazyvim

A couple additions once lazyvim is running:

```
:MasonInstall oxlint
```

### Disable Spotlight keyboard shortcuts

Uncheck "Show Spotlight Search" in System Settings > Keyboard > Keyboard
Shortcuts > Spotlight
