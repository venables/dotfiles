# =============================================================================
# .zprofile — sourced for login shells only
# =============================================================================
# Runs after .zshenv and before .zshrc, for login shells (e.g. `zsh -l`,
# SSH interactive login, macOS Terminal's default).
#
# Intentionally empty: PATH/env setup lives in .zshenv so non-interactive
# SSH commands and scripts get the same environment. Interactive setup
# lives in .zshrc. Add things here only if they must run exactly once per
# login session (e.g. starting ssh-agent, fortune/motd banners).
# =============================================================================
