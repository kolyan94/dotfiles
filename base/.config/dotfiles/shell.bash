# Personal shell layer, sourced from the END of ~/.bashrc (see install.sh) and from ~/.zshrc.
#
# ADDITIVE ONLY. Omarchy owns the bash setup (aliases, zoxide, fzf, starship,
# mise, history, inputrc); this file only adds NEW names and never changes how an
# existing command, key or variable behaves. Rules:
#   - never redefine an Omarchy alias/function (c, t, a, d, r, h, n, g, ga, gd,
#     ls, lt, ff, eff, cd, open, ...) or a system command (cp, rm, cat, ...)
#   - never export EDITOR / BROWSER / TERMINAL / PAGER / LC_ALL
# Anything that overrides a default lives in overrides/.config/dotfiles/overrides.bash (opt-in).

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
# Arch ships no vi/vim here; fill the gap with nvim (a real vi/vim, if installed later, wins)
command -v vi &>/dev/null || alias vi='nvim'
command -v vim &>/dev/null || alias vim='nvim'
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

# swiftly installs Ubuntu builds on Arch: re-link their libraries after a new toolchain lands
if command -v swiftly &>/dev/null; then
  swiftly() {
    command swiftly "$@" || return
    case $1 in install | update) command -v swiftly-arch-fix &>/dev/null && swiftly-arch-fix ;; esac
    return 0
  }
fi

#######################################################
# Embedded (ESP32 / Arduino / Pico / Playdate)
#######################################################

# Serial monitor: serial [port] [baud]. With no port, picks from /dev/ttyUSB* /dev/ttyACM*
# (fzf when there are several). Uses tio if installed, else PlatformIO's monitor.
serial() {
  local port=$1 baud=${2:-115200} p ports=""
  if [[ -z $port ]]; then
    for p in /dev/ttyUSB* /dev/ttyACM*; do [[ -e $p ]] && ports+="$p"$'\n'; done
    [[ -z $ports ]] && { echo "serial: no /dev/ttyUSB* or /dev/ttyACM* device" >&2; return 1; }
    port=$(printf '%s' "$ports" | fzf --select-1 --prompt="port> ") || return
  fi
  [[ -r $port && -w $port ]] || echo "serial: no access to $port (add yourself to uucp, then log out and back in)" >&2
  if command -v tio &>/dev/null; then
    tio -b "$baud" "$port"
  else
    pio device monitor -p "$port" -b "$baud"
  fi
}

# Playdate SDK: the AUR package exports this from /etc/profile.d, which only login shells read
if [[ -z ${PLAYDATE_SDK_PATH:-} && -d ${XDG_DATA_HOME:-$HOME/.local/share}/playdate-sdk ]]; then
  export PLAYDATE_SDK_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/playdate-sdk"
fi

# Build a Playdate Lua project (source/ -> <dir name>.pdx) and open it in the simulator
pdrun() {
  local dir=${1:-.} name
  name=$(basename -- "$(cd -- "$dir" && pwd)")
  pdc -- "$dir/source" "$dir/$name.pdx" && runfree PlaydateSimulator "$dir/$name.pdx"
}

# Random-height bars across the width of the screen
random_bars() {
  local chars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █) cols i out=""
  cols=$(tput cols)
  for ((i = 0; i < cols; i++)); do out+=${chars[RANDOM % ${#chars[@]}]}; done
  echo "$out"
}

# Opt-in layer that changes defaults (installed by `./install.sh --with-overrides`).
# Bash only: it uses `bind` and readline settings. zsh loads overrides.zsh from ~/.zshrc instead.
[[ -n ${BASH_VERSION:-} && -r ~/.config/dotfiles/overrides.bash ]] && source ~/.config/dotfiles/overrides.bash
