# OPT-IN bash overrides: these change how existing Omarchy/system behavior works.
# Linked to ~/.config/dotfiles/overrides.bash by `./install.sh --with-shell-overrides`
# and sourced at the end of shell.bash. Interactive shells only.
# The aliases and fzf look shared with zsh live in overrides.sh.

[[ $- == *i* ]] || return 0

# Vi editing mode (was zsh-vi-mode): blinking beam = insert, blinking block = normal.
# fzf binds Ctrl-R/Ctrl-T/Alt-C in the vi keymaps itself.
set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string "\1\e[5 q\2"'
bind 'set vi-cmd-mode-string "\1\e[1 q\2"'
# Omarchy's arrow-key history search is bound in the emacs keymap; mirror it
bind -m vi-insert '"\e[A": history-search-backward'
bind -m vi-insert '"\e[B": history-search-forward'
bind -m vi-command '"\e[A": history-search-backward'
bind -m vi-command '"\e[B": history-search-forward'

[[ -r ~/.config/dotfiles/overrides.sh ]] && source ~/.config/dotfiles/overrides.sh
