#!/usr/bin/env bash
# Install these dotfiles on an Omarchy system with GNU Stow. Safe to re-run.
#
#   ./install.sh                    stow base (ADDITIVE layer: new commands, keys, plugins,
#                                   tools; changes no Omarchy default) and zsh
#   ./install.sh --with-overrides   also stow overrides (things that change defaults:
#                                   vi mode, safety aliases, kitty cursor, starship prompt,
#                                   lazygit theme, nvim options and behavior plugins, ...)
#   ./install.sh --without-overrides   unstow overrides again
#   ./install.sh --dry-run          print what would change, touch nothing
#   ./install.sh --no-tools         skip mise / tpm / Neovim plugin sync (no network)
#
# Model: each top-level package (base, zsh, overrides) mirrors $HOME and is stowed with
# --no-folding, so every file is its own symlink and directories like ~/.config/nvim stay
# real, owned by Omarchy / the app. Files that would block a link are moved to a timestamped
# backup first, never deleted. Omarchy-owned files (~/.bashrc, kitty.conf, tmux.conf) are
# never replaced, they only get one marked include block appended, so `omarchy update` and
# theme switching keep working. After `omarchy refresh tmux|kitty` or a fresh ~/.bashrc,
# re-run this.
set -euo pipefail

DRY=0
TOOLS=1
OVERRIDES=keep # keep | on | off
for arg in "$@"; do
  case $arg in
    --dry-run) DRY=1 ;;
    --no-tools) TOOLS=0 ;;
    --with-overrides) OVERRIDES=on ;;
    --without-overrides) OVERRIDES=off ;;
    -h | --help) sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
CONFIG=$HOME/.config # the packages mirror $HOME, so this is where stow puts .config
BACKUP=${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backup/$(date +%Y%m%d-%H%M%S)

say() { printf '%s\n' "$*"; }
run() { if ((DRY)); then say "  [dry-run] $*"; else "$@"; fi; }

[[ $EUID -ne 0 ]] || { say "Run as your user, not root." >&2; exit 1; }
[[ -d /usr/share/omarchy ]] || { say "This branch targets Omarchy (/usr/share/omarchy not found)." >&2; exit 1; }
command -v stow &>/dev/null || { say "GNU Stow is required: sudo pacman -S stow" >&2; exit 1; }

# points_into_repo LINK: true if LINK is a symlink whose target path lies inside this repo
points_into_repo() {
  [[ -L $1 ]] || return 1
  local target
  target=$(readlink -- "$1")
  [[ $target == /* ]] || target=$(dirname -- "$1")/$target
  [[ $(realpath -ms -- "$target") == "$REPO"/* ]]
}

# drop_link LINK: remove a symlink into this repo
drop_link() {
  say "  unlink  $1"
  run rm -- "$1"
}

# prepare PACKAGE: move anything that would stop stow from linking PACKAGE's files to the
# backup dir. A path is fine when it is missing or already resolves to the package file.
prepare() {
  local pkg=$REPO/$1 f dest rel
  while IFS= read -r -d '' f; do
    dest=$HOME/${f#"$pkg"/}
    [[ -e $dest || -L $dest ]] || continue
    [[ $(realpath -m -- "$dest") == "$f" ]] && continue
    if points_into_repo "$dest"; then
      drop_link "$dest" # a link from the pre-stow installer or a moved file
      continue
    fi
    rel=${dest#"$HOME"/}
    say "  backup  $dest -> $BACKUP/$rel"
    run mkdir -p "$(dirname "$BACKUP/$rel")"
    run mv -- "$dest" "$BACKUP/$rel"
  done < <(find "$pkg" -type f -print0 | sort -z)
}

stow_pkg() {
  say "  stow    $1"
  prepare "$1"
  run stow --no-folding --restow --dir="$REPO" --target="$HOME" "$1"
}

unstow_pkg() {
  say "  unstow  $1"
  run stow --delete --dir="$REPO" --target="$HOME" "$1"
}

# ensure_block FILE BEGIN_MARK LINE...: append a marked block once
ensure_block() {
  local file=$1 mark=$2
  shift 2
  if [[ -f $file ]] && grep -qF -- "$mark" "$file"; then
    return 0
  fi
  if [[ ! -f $file ]]; then
    say "  skip    $file does not exist (start the app once, then re-run)"
    return 0
  fi
  say "  append  $file"
  if ((!DRY)); then
    {
      printf '\n%s\n' "$mark"
      printf '%s\n' "$@"
      printf '# <<< dotfiles <<<\n'
    } >>"$file"
  fi
}

# Overrides stay as they are unless asked: on if they are stowed now
if [[ $OVERRIDES == keep ]]; then
  OVERRIDES=off
  [[ -L $CONFIG/dotfiles/overrides.bash ]] && points_into_repo "$CONFIG/dotfiles/overrides.bash" && OVERRIDES=on
  [[ $OVERRIDES == off ]] && OVERRIDES=skip
fi

say "==> Cleaning links into this repo whose target is gone"
# Earlier layouts linked other paths (absolute links, a whole-directory link for the
# wallpapers). Only symlinks that point into this repo are touched.
while IFS= read -r -d '' l; do
  points_into_repo "$l" && drop_link "$l"
done < <(find "$HOME" -maxdepth 1 -xtype l -print0; find "$CONFIG" -xtype l -print0 2>/dev/null)

say "==> Stowing packages"
stow_pkg base
case $OVERRIDES in
  on) stow_pkg overrides ;;
  off)
    unstow_pkg overrides
    say "  note: restore Omarchy's stock starship prompt with: omarchy refresh config starship.toml"
    ;;
esac

# First render: the current theme was applied before the template existed, so refresh it
# (`omarchy theme refresh` skips the wallpaper change) to create yazi's theme.toml.
if ((!DRY)) && [[ ! -f $CONFIG/yazi/theme.toml ]] && command -v omarchy &>/dev/null; then
  say "  theme   rendering yazi theme (omarchy theme refresh)"
  omarchy theme refresh >/dev/null 2>&1 || say "  warn: omarchy theme refresh failed, run it manually"
fi

say "==> Hooking into Omarchy's files"
ensure_block "$HOME/.bashrc" "# >>> dotfiles (shell layer) >>>" \
  '[[ -r ~/.config/dotfiles/shell.bash ]] && source ~/.config/dotfiles/shell.bash'
ensure_block "$CONFIG/kitty/kitty.conf" "# >>> dotfiles (kitty overrides) >>>" \
  'include ~/.config/kitty/dotfiles.conf'
ensure_block "$CONFIG/tmux/tmux.conf" "# >>> dotfiles (tmux additions) >>>" \
  'source-file -q ~/.config/tmux/dotfiles.conf'

if ((TOOLS)); then
  say "==> Tools"
  if command -v mise &>/dev/null; then
    run mise install --yes || say "  warn: mise install failed (network?), re-run later"
  fi
  # tpm and every `@plugin` in dotfiles.conf: cloning into ~/.config/tmux/plugins/<name>
  # is exactly what tpm's prefix+I does, and tpm treats an existing dir as installed
  while IFS= read -r plugin; do
    dir=$CONFIG/tmux/plugins/${plugin##*/}
    [[ -d $dir ]] && continue
    say "  clone   $plugin"
    run git clone --depth 1 "https://github.com/$plugin" "$dir" ||
      say "  warn: could not clone $plugin, re-run later"
  done < <(grep -oP "@plugin '\K[^']+" "$REPO/base/.config/tmux/dotfiles.conf")
  if command -v nvim &>/dev/null; then
    say "  nvim    syncing plugins (headless)"
    run nvim --headless "+Lazy! sync" +qa || say "  warn: Lazy sync reported errors, open nvim and run :Lazy"
  fi
fi

say "==> Done"
if ((DRY)); then
  say "Dry run only, nothing was changed."
else
  say "Backups (if any): $BACKUP"
  say "Open a new terminal to load the shell layer. Reload running apps with:"
  say "  kitty:  ctrl+shift+f5     tmux:  prefix + q"
fi
