# Python helpers shared by bash and zsh on macOS and Omarchy. Sourced natively by ~/.zshrc and,
# for bash, by shell.bash. Keep it portable (bash 3.2 on macOS, no zsh-only syntax).

[[ $- == *i* ]] || return 0

command -v python >/dev/null 2>&1 || alias python='python3'
alias py='python3'

# va: activate the nearest .venv/ or venv/, looking up from the current directory
va() {
  local d=$PWD v
  while :; do
    for v in .venv venv; do
      if [[ -f $d/$v/bin/activate ]]; then
        . "$d/$v/bin/activate"
        return
      fi
    done
    [[ $d == / ]] && break
    d=$(dirname -- "$d")
  done
  echo "va: no .venv or venv above $PWD" >&2
  return 1
}
alias vd='deactivate'

# mkvenv [python version]: create .venv here (uv when available, it is much faster) and activate it
mkvenv() {
  if command -v uv >/dev/null 2>&1; then
    if [[ -n ${1:-} ]]; then uv venv --python "$1" .venv; else uv venv .venv; fi || return
  else
    python3 -m venv .venv || return
  fi
  . .venv/bin/activate
}

# uv / uvx completion
if command -v uv >/dev/null 2>&1; then
  if [[ -n ${ZSH_VERSION:-} ]]; then
    eval "$(uv generate-shell-completion zsh)"
    eval "$(uvx --generate-shell-completion zsh)"
  elif [[ -n ${BASH_VERSION:-} ]]; then
    eval "$(uv generate-shell-completion bash)"
    eval "$(uvx --generate-shell-completion bash)"
  fi
fi
