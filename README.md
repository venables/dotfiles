```
█▀▀▄ █▀▀█ ▀▀█▀▀ █▀▀▀ ▀█▀ █░░░ █▀▀▀ █▀▀▀
█░░█ █░░█ ░░█░░ █▀▀░ ░█░ █░░░ █▀▀▀ ▀▀▀█
▀▀▀▀ ▀▀▀▀ ░░▀░░ ▀░░░ ▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀

# Get started

$>
git clone git@githb.com:venables/dotfiles.git ~/.dotfiles

$>
cd ~/.dotfiles

$>
./install.sh
```

## Getting started

### New computer

1. `xcode-select -install`
1. Open Terminal.app
1. [Generate a new SSH key](#generate-a-new-key)
1. Add it to Github's [SSH and GPG Keys](https://github.com/settings/keys) page

### Installation

1. Clone the repo

```sh
git clone git@githb.com:venables/dotfiles.git ~/.dotfiles
```

2. Run the setup

```sh
cd ~/.dotfiles
./install.sh
```

### Individual tasks

```sh
./scripts/brew.sh      # Install/update Homebrew and packages
./scripts/symlink.sh   # Create symlinks for dotfiles
./scripts/mise.sh      # Install/update Mise
./scripts/zsh.sh       # Setup Zsh
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
