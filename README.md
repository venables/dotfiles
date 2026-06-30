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
   - Installing/updating CLI tools (Claude Code, OpenCode)
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

## Troubleshooting

### 1Password extension won't connect (Chromium forks: Helium, etc.)

**Symptom:** the extension never links to the desktop app and the browser
console loops on:

```
[AppIntegration] Desktop app port disconnected. Error: Specified native messaging host not found.
[AppIntegration] Desktop app connection attempt failed: NativeHostNotFound
```

**Cause:** 1Password only auto-installs its native-messaging manifest for
browsers on its built-in list. A Chromium fork's native-messaging directory is
keyed by the fork's **own bundle id** (e.g. Helium = `net.imput.helium`), so the
manifest never lands there. Adding the browser to 1Password's allowlist lets the
extension load but does **not** write the manifest, so the browser has no host
to launch.

**Fix:** write 1Password's manifest into the fork's own `NativeMessagingHosts`
directory. Adjust the bundle id (`net.imput.helium`) for other forks, and the
`"path"` if 1Password isn't in `/Applications`.

```sh
read -r -d '' MANIFEST <<'JSON'
{
  "name": "com.1password.1password",
  "description": "1Password BrowserSupport",
  "path": "/Applications/1Password.app/Contents/Library/LoginItems/1Password Browser Helper.app/Contents/MacOS/1Password-BrowserSupport",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://aeblfdkhhhdcdjpifhhbdiojplfjncoa/",
    "chrome-extension://hjlinigoblmkhjejkmbegnoaljkphmgo/",
    "chrome-extension://bkpbhnjcbehoklfkljkkbbmipaphipgl/",
    "chrome-extension://gejiddohjgogedgjnonbofjigllpkmbf/",
    "chrome-extension://khgocmkkpikpnmmkgmdnfckapcdkgfaf/",
    "chrome-extension://dppgmdbiimibapkepcbdbmkaabgiofem/"
  ]
}
JSON

d="$HOME/Library/Application Support/net.imput.helium/NativeMessagingHosts"
mkdir -p "$d" && printf '%s\n' "$MANIFEST" > "$d/com.1password.1password.json"
```

Then fully quit and relaunch the browser. If 1Password still rejects the
connection (vs. failing to find it), open **1Password > Settings > Browser** and
re-add the browser as a custom/other trusted app -- that record is
integrity-signed by 1Password and can't be hand-edited or copied between
machines.

The `allowed_origins` are 1Password's public extension IDs and the `"path"` is
the standard install location, so this manifest is not machine-specific -- it's
the same file 1Password generates for any supported browser.
