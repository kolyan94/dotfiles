# zsh on Omarchy, via the omarchy-zsh package (sudo pacman -S omarchy-zsh). This replaces
# the package's `omarchy-setup-zsh`, which would overwrite ~/.bashrc as well.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load zsh options, keybindings, and completion
[[ -f /usr/share/omarchy-zsh/shell/zoptions ]] && source /usr/share/omarchy-zsh/shell/zoptions

# Load shared shell configuration (aliases, functions, environment, tool init)
[[ -f /usr/share/omarchy-zsh/shell/all ]] && source /usr/share/omarchy-zsh/shell/all

# dotfiles shell layer, shared with bash. Its functions are bash-style (0-based arrays in
# random_bars), so load them with sh emulation, which stays attached to the functions
[[ -r ~/.config/dotfiles/shell.bash ]] && emulate sh -c 'source ~/.config/dotfiles/shell.bash'

# Personal choice over Omarchy's c='opencode'
alias c='clear'

# Opt-in layer that changes defaults (installed by `./install.sh --with-shell-overrides`)
[[ -r ~/.config/dotfiles/overrides.zsh ]] && source ~/.config/dotfiles/overrides.zsh
