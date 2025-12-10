# PATH
typeset -U path  # unique entries only

path=(
  "$HOME/.opencode/bin"           # opencode CLI
  "$HOME/.local/bin"              # user-local binaries
  "$HOME/.local/share/solana/install/active_release/bin"  # solana toolchain
  $path
)
