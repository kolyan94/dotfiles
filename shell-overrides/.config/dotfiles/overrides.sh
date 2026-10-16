# OPT-IN shell overrides shared by bash and zsh: aliases that change system commands and the fzf
# look. Linked by `./install.sh --with-shell-overrides` (or --with-overrides), sourced by overrides.bash and overrides.zsh.
# Keep it portable (no `bind`, no `bindkey`).

[[ $- == *i* ]] || return 0

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

# Omarchy aliases not used here (r=rails)
unalias r 2>/dev/null

# vi/vim -> nvim even when a real vi/vim is installed (base only fills in when they are missing)
command -v nvim &>/dev/null && alias vi='nvim' && alias vim='nvim'
command -v bat &>/dev/null && alias cat='bat'
command -v btop &>/dev/null && alias top='btop'
