# OPT-IN zsh overrides, the zsh twin of overrides.bash. Linked by `./install.sh --with-overrides`
# and sourced at the end of ~/.zshrc, after omarchy-zsh. Interactive shells only.

[[ -o interactive ]] || return 0

# Vi editing mode: blinking beam = insert, blinking block = normal
bindkey -v
KEYTIMEOUT=1 # Esc switches to normal mode without the default 0.4s wait

# omarchy-zsh binds its keys in the emacs keymap (Tab routing, Shift-Tab, arrow history search,
# fzf's Ctrl-R/Ctrl-T/Alt-C); carry them over to vi insert mode, and history search to normal mode
() {
  local key widget
  for key in '^I' '^[[Z' '^R' '^T' '^[c' '^[[A' '^[[B'; do
    widget=${${(z)"$(bindkey -M emacs "$key")"}[2]}
    [[ -n $widget && $widget != undefined-key ]] && bindkey -M viins "$key" "$widget"
  done
  bindkey -M vicmd '^[[A' history-search-backward
  bindkey -M vicmd '^[[B' history-search-forward
  bindkey -M vicmd '^R' "${${(z)"$(bindkey -M emacs '^R')"}[2]}"
}

_dotfiles_vi_cursor() {
  if [[ $KEYMAP == vicmd ]]; then printf '\e[1 q'; else printf '\e[5 q'; fi
}
zle-keymap-select() { _dotfiles_vi_cursor }
zle-line-init() { _dotfiles_vi_cursor }
zle -N zle-keymap-select
zle -N zle-line-init

[[ -r ~/.config/dotfiles/overrides.sh ]] && source ~/.config/dotfiles/overrides.sh
