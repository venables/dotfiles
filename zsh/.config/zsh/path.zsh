# PATH
typeset -U path  # unique entries only

if [[ -z "${HOMEBREW_PREFIX:-}" ]] && command -v brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
fi

path=(
  "$HOME/.opencode/bin"           # opencode CLI
  "$HOME/.local/bin"              # user-local binaries
  "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/libpq/bin" # psql command
  "$HOME/.local/share/solana/install/active_release/bin"  # solana toolchain
  "$HOME/.foundry/bin"            # foundry
  $path
)
