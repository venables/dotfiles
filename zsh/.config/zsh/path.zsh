# PATH
typeset -U path  # unique entries only

path=(
  "$HOME/.opencode/bin"           # opencode CLI
  "$HOME/.local/bin"              # user-local binaries
  "$HOMEBREW_PREFIX/opt/libpq/bin" # psql command
  "$HOME/.local/share/solana/install/active_release/bin"  # solana toolchain
  $path
)
