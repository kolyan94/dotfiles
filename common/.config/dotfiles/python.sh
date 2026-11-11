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
    # Generated once into a cache dir on fpath and autoloaded on first Tab; eval-ing it on every start cost
    # ~2.4 s on the Radxa. Regenerated weekly, so uv upgrades get new completions.
    _dotfiles_cdir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh-completions
    mkdir -p "$_dotfiles_cdir"
    if [[ ! -s $_dotfiles_cdir/_uv || -n $(find "$_dotfiles_cdir/_uv" -mtime +7 2>/dev/null) ]]; then
      uv generate-shell-completion zsh >| "$_dotfiles_cdir/_uv"
      uvx --generate-shell-completion zsh >| "$_dotfiles_cdir/_uvx"
    fi
    fpath=("$_dotfiles_cdir" $fpath)
    autoload -Uz _uv _uvx
    compdef _uv uv
    compdef _uvx uvx
    unset _dotfiles_cdir
  elif [[ -n ${BASH_VERSION:-} ]]; then
    eval "$(uv generate-shell-completion bash)"
    eval "$(uvx --generate-shell-completion bash)"
  fi
fi
