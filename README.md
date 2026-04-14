# @venables/dotfiles

```
█▀▀▄ █▀▀█ ▀▀█▀▀ █▀▀▀ ▀█▀ █░░░ █▀▀▀ █▀▀▀
█░░█ █░░█ ░░█░░ █▀▀░ ░█░ █░░░ █▀▀▀ ▀▀▀█
▀▀▀▀ ▀▀▀▀ ░░▀░░ ▀░░░ ▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀
```

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

#### Add to GitHub

Copy the public key to your clipboard:

```sh
cat ~/.ssh/id_ed25519.pub | pbcopy
```

Then in GitHub under **Settings > SSH and GPG keys**, add the key twice:

1. **New SSH key** — Key type: **Authentication Key**
2. **New SSH key** — Key type: **Signing Key**

### Neovim / Lazyvim

A couple additions once lazyvim is running:

```
:MasonInstall oxlint
```

### Disable Spotlight keyboard shortcuts

Uncheck "Show Spotlight Search" in System Settings > Keyboard > Keyboard
Shortcuts > Spotlight
