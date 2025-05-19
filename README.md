# Dotfiles & Configs

These are my dotfiles and config files, tuned for my workflows on MacOS systems. The init script will get you up and running from zero-to-one on a brand new computer.

## Getting started

I recommend cloning this repository to your `<HOME>/.dotfiles` directory, and then run

```sh
./install
```

## Directory structure

```
.
├── install           # Main installation script
├── Brewfile          # Homebrew package definitions
├── dotfiles/         # Configuration files
│   ├── config/       # Application configs
│   ├── git/          # Git configuration
│   ├── gnupg/        # GPG configuration
│   ├── vscode/       # VS Code (Cursor) settings
│   └── zsh/          # Zsh configuration
└── scripts/          # Helper scripts
    ├── asdf.sh       # ASDF version manager setup
    ├── brew.sh       # Homebrew installation
    ├── symlink.sh    # Creates symlinks for dotfiles
    └── zsh.sh        # Zsh shell setup
```

## Signing git commits

### Generate a new key

```sh
# Generate a new key
gpg --batch --generate-key <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Matt Venables
Name-Email: matt@venabl.es
Expire-Date: 0
%commit
EOF
```

### List the latest key ID

Useful for updating your gitconfig

```sh
gpg --list-secret-keys --keyid-format LONG | grep sec | tail -n 1 | awk '{print $2}' | cut -d'/' -f2
```

### Copy the latest public key to the clipboard

Useful for pasting into github

```sh
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep sec | tail -n 1 | awk '{print $2}' | cut -d'/' -f2)

# Export the public key and copy to clipboard
gpg --armor --export $KEY_ID | pbcopy

# Let the user know it worked
echo "Key $KEY_ID copied to clipboard. Paste it into GitHub"
```

### Export the latest key (public and private)

```sh
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep sec | tail -n 1 | awk '{print $2}' | cut -d'/' -f2)

# Export public key to file

gpg --output public-key-$KEY_ID.gpg --armor --export $KEY_ID

# Export private key to file

gpg --output private-key-$KEY_ID.gpg --armor --export-secret-key $KEY_ID

# Let the user know it worked

echo "Keys exported to current directory:"
echo "Public key: public-key-$KEY_ID.gpg"
echo "Private key: private-key-$KEY_ID.gpg"
```

### Import to a new machine (public and private)

```sh
gpg --import public-key-$KEY_ID.gpg
gpg --import --allow-secret-key-import private-key-$KEY_ID.gpg
```
