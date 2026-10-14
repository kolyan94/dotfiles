# Personal shell layer, sourced from the END of ~/.bashrc (see install.sh).
#
# ADDITIVE ONLY. Omarchy owns the bash setup (aliases, zoxide, fzf, starship,
# mise, history, inputrc); this file only adds NEW names and never changes how an
# existing command, key or variable behaves. Rules:
#   - never redefine an Omarchy alias/function (c, t, a, d, r, h, n, g, ga, gd,
#     ls, lt, ff, eff, cd, open, ...) or a system command (cp, rm, cat, ...)
#   - never export EDITOR / BROWSER / TERMINAL / PAGER / LC_ALL
# Anything that overrides a default lives in overrides/shell.bash (opt-in).

[[ $- == *i* ]] || return 0

#######################################################
# PATH (each directory is only added if it exists)
#######################################################
_dots_path() {
  local d
  for d in "$@"; do
    [[ -d $d && ":$PATH:" != *":$d:"* ]] && PATH="$PATH:$d"
  done
}
_dots_path "$HOME/.cargo/bin" "$HOME/.npm-global/bin" "$HOME/.local/share/swiftly/bin"
unset -f _dots_path

#######################################################
# New aliases
#######################################################
alias q='exit'
alias svi='sudo nvim'
alias vis='nvim "+set si"'
command -v lazygit &>/dev/null && alias lg='lazygit'
command -v tldr &>/dev/null && alias help='tldr'
alias iplocal='ip -br -c a'
alias ipexternal='curl -s ifconfig.me && echo'

#######################################################
# New functions
#######################################################

# yazi wrapper: cd into the directory yazi was in when it exits
y() {
  local tmp cwd
  tmp=$(mktemp -t "yazi-cwd.XXXXXX")
  yazi "$@" --cwd-file="$tmp"
  if cwd=$(cat -- "$tmp") && [[ -n $cwd && $cwd != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Start a program detached from the terminal
runfree() {
  "$@" >/dev/null 2>&1 &
  disown
}

# Copy with a progress bar
cpp() {
  if command -v rsync &>/dev/null; then
    rsync -ah --info=progress2 -- "$1" "$2"
  else
    command cp -v -- "$1" "$2"
  fi
}

# Copy / move, then cd into the destination if it is a directory
cpg() {
  if [[ -d $2 ]]; then command cp -- "$1" "$2" && builtin cd -- "$2"; else command cp -- "$1" "$2"; fi
}
mvg() {
  if [[ -d $2 ]]; then command mv -- "$1" "$2" && builtin cd -- "$2"; else command mv -- "$1" "$2"; fi
}

# mkdir + cd
mkdirg() {
  command mkdir -p -- "$1" && builtin cd -- "$1"
}

# Random-height bars across the width of the screen
random_bars() {
  local chars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █) cols i out=""
  cols=$(tput cols)
  for ((i = 0; i < cols; i++)); do out+=${chars[RANDOM % ${#chars[@]}]}; done
  echo "$out"
}

# Opt-in layer that changes defaults (installed by `./install.sh --with-overrides`)
[[ -r ~/.config/dotfiles/overrides.bash ]] && source ~/.config/dotfiles/overrides.bash
