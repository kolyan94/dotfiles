# OPT-IN shell overrides: these change how existing Omarchy/system behavior works.
# Linked to ~/.config/dotfiles/overrides.bash by `./install.sh --with-overrides`
# and sourced at the end of shell.bash. Interactive shells only.

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

# fzf look: layout only, colors come from the terminal palette (theme-aware)
if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }\
--info=inline-right --ansi --layout=reverse --border=rounded \
--color=border:cyan,header:yellow,hl:cyan,hl+:cyan,info:bright-black,marker:magenta,pointer:magenta,prompt:cyan,scrollbar:cyan,separator:yellow,spinner:magenta"
fi

# Safer / friendlier versions of system commands
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

command -v nvim &>/dev/null && alias vi='nvim' && alias vim='nvim'
command -v bat &>/dev/null && alias cat='bat'
command -v btop &>/dev/null && alias top='btop'
