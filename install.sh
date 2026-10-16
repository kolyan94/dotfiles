#!/usr/bin/env bash
# Install these dotfiles with GNU Stow on macOS or Omarchy. Safe to re-run.
#
#   ./install.sh                    stow the packages for this OS:
#                                     macOS:   common + common-overrides + macos
#                                     Omarchy: common + omarchy (ADDITIVE: changes no Omarchy default)
#   ./install.sh --with-overrides   Omarchy: also stow common-overrides + omarchy-overrides
#                                   (vi mode, safety aliases, starship prompt, nvim behavior, ...)
#   ./install.sh --without-overrides   Omarchy: unstow them again
#   ./install.sh --dry-run          print what would change, touch nothing
#   ./install.sh --no-tools         skip mise / tpm / Neovim plugin sync (no network)
#   ./install.sh --os macos|omarchy force the platform (testing)
#
# Model: each package dir mirrors $HOME and is stowed with --no-folding, so every file is its
# own symlink and directories like ~/.config/nvim stay real. Files that would block a link are
# moved to a timestamped backup first, never deleted. On Omarchy, Omarchy-owned files
# (~/.bashrc, kitty.conf, tmux.conf) are never replaced, they only get one marked include
# block appended; after `omarchy refresh tmux|kitty` or a fresh ~/.bashrc, re-run this.
# Runs on macOS's bash 3.2 and BSD tools: no realpath -m, find -xtype, grep -P, mapfile.
set -euo pipefail

DRY=0
TOOLS=1
OVERRIDES=keep # keep | on | off
OS=""
while (($#)); do
  case $1 in
    --dry-run) DRY=1 ;;
    --no-tools) TOOLS=0 ;;
    --with-overrides) OVERRIDES=on ;;
    --without-overrides) OVERRIDES=off ;;
    --os) OS=${2:-}; shift ;;
    -h | --help) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
CONFIG=$HOME/.config # the packages mirror $HOME, so this is where stow puts .config
BACKUP=${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backup/$(date +%Y%m%d-%H%M%S)
ALL_PACKAGES="common common-overrides macos omarchy omarchy-overrides"

say() { printf '%s\n' "$*"; }
run() { if ((DRY)); then say "  [dry-run] $*"; else "$@"; fi; }

if [[ -z $OS ]]; then
  if [[ $(uname -s) == Darwin ]]; then
    OS=macos
  elif [[ -d /usr/share/omarchy ]]; then
    OS=omarchy
  else
    say "Unsupported system: expected macOS or Omarchy (/usr/share/omarchy)." >&2
    exit 1
  fi
fi
case $OS in macos | omarchy) ;; *) say "--os must be macos or omarchy" >&2; exit 2 ;; esac

[[ $EUID -ne 0 ]] || { say "Run as your user, not root." >&2; exit 1; }
if ! command -v stow >/dev/null 2>&1; then
  if [[ $OS == macos ]]; then say "GNU Stow is required: brew install stow" >&2; else say "GNU Stow is required: sudo pacman -S stow" >&2; fi
  exit 1
fi

# normpath PATH: collapse //, /./ and /../ in an absolute path without touching the disk
normpath() {
  local part out="" IFS=/
  set -f
  for part in $1; do
    case $part in
      '' | .) ;;
      ..) out=${out%/*} ;;
      *) out=$out/$part ;;
    esac
  done
  set +f
  printf '%s\n' "${out:-/}"
}

# link_target LINK: absolute, normalized path LINK points at (the target may not exist)
link_target() {
  local target dir
  target=$(readlink -- "$1")
  dir=$(cd -P -- "$(dirname -- "$1")" && pwd)
  [[ $target == /* ]] || target=$dir/$target
  normpath "$target"
}

# points_into_repo LINK: true if LINK is a symlink whose target path lies inside this repo
points_into_repo() {
  [[ -L $1 ]] || return 1
  [[ $(link_target "$1") == "$REPO"/* ]]
}

# in_package PATH: true if PATH is an existing file of one of the packages
in_package() {
  local p
  [[ -e $1 ]] || return 1
  for p in $ALL_PACKAGES; do
    [[ $1 == "$REPO/$p"/* ]] && return 0
  done
  return 1
}

drop_link() {
  say "  unlink  $1"
  run rm -- "$1"
}

backup() {
  local rel=${1#"$HOME"/}
  say "  backup  $1 -> $BACKUP/$rel"
  run mkdir -p "$(dirname -- "$BACKUP/$rel")"
  run mv -- "$1" "$BACKUP/$rel"
}

# prepare PACKAGE: clear anything that would stop stow from linking PACKAGE's files. A path is
# fine when it is missing or already links to the package file.
prepare() {
  local pkg=$REPO/$1 f dest
  while IFS= read -r -d '' f; do
    dest=$HOME/${f#"$pkg"/}
    [[ -e $dest || -L $dest ]] || continue
    [[ -L $dest && $(link_target "$dest") == "$f" ]] && continue
    if points_into_repo "$dest"; then
      drop_link "$dest" # a link from an older layout of this repo
    else
      backup "$dest"
    fi
  done < <(find "$pkg" -type f ! -name .gitignore -print0)
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

say "==> Platform: $OS"

# Overrides: always on for macOS (that config is the original, not a layer). On Omarchy they
# stay as they are unless asked: on if they are stowed now (old or new layout).
if [[ $OS == macos ]]; then
  OVERRIDES=on
elif [[ $OVERRIDES == keep ]]; then
  OVERRIDES=skip
  points_into_repo "$CONFIG/dotfiles/overrides.bash" && OVERRIDES=on
fi

say "==> Cleaning links into this repo that no package owns"
# Older layouts: `stow .` from the repo root (macOS, folded dirs such as ~/.config/nvim -> repo),
# and base/ zsh/ overrides/ (Omarchy). Only symlinks that point into this repo are touched.
while IFS= read -r -d '' l; do
  points_into_repo "$l" || continue
  in_package "$(link_target "$l")" || drop_link "$l"
done < <(
  # -lname prefilter: ~/.config can hold thousands of unrelated links (browsers, node, ...)
  name="*${REPO##*/}/*"
  find "$HOME" -maxdepth 1 -type l -lname "$name" -print0
  [[ -d $CONFIG ]] && find "$CONFIG" -type l -lname "$name" -print0
  [[ -d $HOME/.local/bin ]] && find "$HOME/.local/bin" -type l -lname "$name" -print0
  true
)

say "==> Stowing packages"
stow_pkg common
if [[ $OS == macos ]]; then
  stow_pkg common-overrides
  stow_pkg macos
else
  stow_pkg omarchy
  case $OVERRIDES in
    on)
      stow_pkg common-overrides
      stow_pkg omarchy-overrides
      ;;
    off)
      unstow_pkg omarchy-overrides
      unstow_pkg common-overrides
      say "  note: restore Omarchy's stock starship prompt with: omarchy refresh config starship.toml"
      ;;
  esac
fi

# The old macOS layout linked whole directories (~/.config/tmux -> repo/.config/tmux), so apps
# wrote runtime files into the repo: tpm plugins, lazy-lock.json, nvim spell files. Move the
# ones git no longer tracks to where the apps now look for them.
if [[ -d $REPO/.config ]]; then
  say "==> Moving runtime files left in the repo by the old layout"
  while IFS= read -r -d '' f; do
    dest=$CONFIG/${f#"$REPO/.config/"}
    if [[ -e $dest || -L $dest ]]; then
      backup "$f" # keep the copy already at the destination
    else
      say "  move    $f -> $dest"
      run mkdir -p "$(dirname -- "$dest")"
      run mv -- "$f" "$dest"
    fi
  done < <(find "$REPO/.config" \( -type f -o -type l \) -print0)
  ((DRY)) || find "$REPO/.config" -depth -type d -empty -exec rmdir {} \;
fi

if [[ $OS == omarchy ]]; then
  # First render: the current theme was applied before the template existed, so refresh it
  # (`omarchy theme refresh` skips the wallpaper change) to create yazi's theme.toml.
  if ((!DRY)) && [[ ! -f $CONFIG/yazi/theme.toml ]] && command -v omarchy >/dev/null 2>&1; then
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
fi

if ((TOOLS)); then
  say "==> Tools"
  if command -v mise >/dev/null 2>&1; then
    run mise install --yes || say "  warn: mise install failed (network?), re-run later"
  fi
  # tpm and every `@plugin` line: cloning into ~/.config/tmux/plugins/<name> is exactly what
  # tpm's prefix+I does, and tpm treats an existing dir as installed
  if [[ $OS == macos ]]; then tmux_conf=$REPO/macos/.config/tmux/tmux.conf; else tmux_conf=$REPO/omarchy/.config/tmux/dotfiles.conf; fi
  while IFS= read -r plugin; do
    dir=$CONFIG/tmux/plugins/${plugin##*/}
    [[ -d $dir ]] && continue
    say "  clone   $plugin"
    run git clone --depth 1 "https://github.com/$plugin" "$dir" ||
      say "  warn: could not clone $plugin, re-run later"
  done < <(sed -n "s/^[[:space:]]*set -g @plugin ['\"]\([^'\"]*\)['\"].*/\1/p" "$tmux_conf")
  if command -v nvim >/dev/null 2>&1; then
    say "  nvim    syncing plugins (headless)"
    run nvim --headless "+Lazy! sync" +qa || say "  warn: Lazy sync reported errors, open nvim and run :Lazy"
  fi
fi

say "==> Done"
if ((DRY)); then
  say "Dry run only, nothing was changed."
else
  say "Backups (if any): $BACKUP"
  say "Open a new terminal to load the shell config. Reload running apps with:"
  say "  kitty:  ctrl+shift+f5     tmux:  prefix + q"
fi
