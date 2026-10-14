#!/usr/bin/env bash
# Install these dotfiles on an Omarchy system. Safe to re-run.
#
#   ./install.sh                    apply the ADDITIVE layer only (new commands, keys,
#                                   plugins, tools; changes no Omarchy default)
#   ./install.sh --with-overrides   also apply overrides/ (things that change defaults:
#                                   vi mode, safety aliases, kitty cursor, starship prompt,
#                                   lazygit theme, nvim options and behavior plugins, ...)
#   ./install.sh --without-overrides   remove the override links again
#   ./install.sh --dry-run          print what would change, touch nothing
#   ./install.sh --no-tools         skip mise / tpm / Neovim plugin sync (no network)
#
# Model: files in this repo are symlinked into ~/.config. Anything already there
# is moved to a timestamped backup, never deleted. Omarchy-owned files
# (~/.bashrc, kitty.conf, tmux.conf) are never replaced, they only get one
# marked include block appended, so `omarchy update` and theme switching keep
# working. After `omarchy refresh tmux|kitty` or a fresh ~/.bashrc, re-run this.
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
    -h | --help) sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}
BACKUP=${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backup/$(date +%Y%m%d-%H%M%S)

say() { printf '%s\n' "$*"; }
run() { if ((DRY)); then say "  [dry-run] $*"; else "$@"; fi; }

[[ $EUID -ne 0 ]] || { say "Run as your user, not root." >&2; exit 1; }
[[ -d /usr/share/omarchy ]] || { say "This branch targets Omarchy (/usr/share/omarchy not found)." >&2; exit 1; }

# link SRC DEST: make DEST a symlink to SRC, backing up whatever was there
link() {
  local src=$1 dest=$2
  if [[ -L $dest && $(readlink -- "$dest") == "$src" ]]; then
    return 0
  fi
  # already reachable through a directory symlink into this repo: nothing to back up
  if [[ -e $dest && ! -L $dest && $(readlink -f -- "$dest") == "$REPO"/* ]]; then
    return 0
  fi
  if [[ -e $dest || -L $dest ]]; then
    local rel=${dest#"$HOME"/}
    say "  backup  $dest -> $BACKUP/$rel"
    run mkdir -p "$(dirname "$BACKUP/$rel")"
    run mv -- "$dest" "$BACKUP/$rel"
  fi
  say "  link    $dest"
  run mkdir -p "$(dirname "$dest")"
  run ln -s -- "$src" "$dest"
}

# link_tree SRC_DIR DEST_DIR: link every file under SRC_DIR individually, so DEST_DIR stays a
# real directory owned by the app / Omarchy (which may write other files into it)
link_tree() {
  local src=$1 dest=$2 f
  while IFS= read -r -d '' f; do
    link "$f" "$dest/${f#"$src"/}"
  done < <(find "$src" -type f -print0 | sort -z)
}

# unlink DEST: remove DEST only if it is a symlink into this repo
unlink_own() {
  local dest=$1
  if [[ -L $dest && $(readlink -- "$dest") == "$REPO"/* ]]; then
    say "  unlink  $dest"
    run rm -- "$dest"
  fi
}

# link_overrides ACTION: ACTION is `link` or `unlink_own`; one place lists every override
link_overrides() {
  local act=$1 f
  "$act" "$REPO/overrides/shell.bash" "$CONFIG/dotfiles/overrides.bash"
  "$act" "$REPO/overrides/kitty.conf" "$CONFIG/kitty/dotfiles-overrides.conf"
  "$act" "$REPO/overrides/tmux.conf" "$CONFIG/tmux/dotfiles-overrides.conf"
  "$act" "$REPO/overrides/starship.toml" "$CONFIG/starship.toml"
  "$act" "$REPO/overrides/lazygit.yml" "$CONFIG/lazygit/config.yml"
  while IFS= read -r -d '' f; do
    "$act" "$f" "$CONFIG/nvim/${f#"$REPO/overrides/nvim/"}"
  done < <(find "$REPO/overrides/nvim" -type f -print0 | sort -z)
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

say "==> Linking config"
link "$REPO/.config/dotfiles/shell.bash" "$CONFIG/dotfiles/shell.bash"
link "$REPO/.config/kitty/dotfiles.conf" "$CONFIG/kitty/dotfiles.conf"
link "$REPO/.config/tmux/dotfiles.conf" "$CONFIG/tmux/dotfiles.conf"
link "$REPO/.config/mise/conf.d/dotfiles.toml" "$CONFIG/mise/conf.d/dotfiles.toml"
# yazi used to be linked as one directory; it needs to stay real so the hook can write theme.toml
unlink_own "$CONFIG/yazi"
link_tree "$REPO/.config/yazi" "$CONFIG/yazi"
# Omarchy theme integration: a template Omarchy renders on every theme change, plus the
# hook that copies the result into yazi's config
link_tree "$REPO/.config/omarchy/themed" "$CONFIG/omarchy/themed"
link_tree "$REPO/.config/omarchy/hooks" "$CONFIG/omarchy/hooks"
link "$REPO/.config/omarchy/backgrounds/tokyo-night" "$CONFIG/omarchy/backgrounds/tokyo-night"

# First render: the current theme was applied before the template existed, so refresh it
# (`omarchy theme refresh` skips the wallpaper change) to create yazi's theme.toml.
if ((!DRY)) && [[ ! -f $CONFIG/yazi/theme.toml ]] && command -v omarchy &>/dev/null; then
  say "  theme   rendering yazi theme (omarchy theme refresh)"
  omarchy theme refresh >/dev/null 2>&1 || say "  warn: omarchy theme refresh failed, run it manually"
fi

# Neovim: link file by file into Omarchy's config dir. The directory itself stays
# Omarchy's, so lua/plugins/theme.lua (a symlink Omarchy rewrites) is untouched.
while IFS= read -r -d '' f; do
  link "$f" "$CONFIG/nvim/${f#"$REPO/.config/nvim/"}"
done < <(find "$REPO/.config/nvim" -type f -print0 | sort -z)

# Drop links this repo created earlier whose target has since moved or been removed
# (only symlinks that point into this repo; anything else is left alone)
while IFS= read -r -d '' l; do
  [[ $(readlink -- "$l") == "$REPO"/* ]] && unlink_own "$l"
done < <(find "$CONFIG/nvim" "$CONFIG/kitty" "$CONFIG/tmux" "$CONFIG/dotfiles" "$CONFIG/lazygit" "$CONFIG/mise" \
  "$CONFIG/starship.toml" -xtype l -print0 2>/dev/null)

case $OVERRIDES in
  on)
    say "==> Linking overrides (change defaults, opt-in)"
    link_overrides link
    ;;
  off)
    say "==> Removing overrides"
    link_overrides unlink_own
    say "  note: restore Omarchy's stock starship prompt with: omarchy refresh config starship.toml"
    ;;
esac

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
  done < <(grep -oP "@plugin '\K[^']+" "$REPO/.config/tmux/dotfiles.conf")
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
