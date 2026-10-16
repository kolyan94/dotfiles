# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this is

The `omarchy` branch of a personal dotfiles repo, targeting an [Omarchy](https://omarchy.org) machine
(Arch + Hyprland + zsh via omarchy-zsh, with bash still supported + kitty + tmux + LazyVim).
**Omarchy is the base; this is an overlay.** By default it may only ADD (new commands, keys on unused
keys, new plugins/tools). It must never replace or edit files Omarchy owns, and must not change any
existing Omarchy/LazyVim/system default. Anything that does change a default goes in `overrides/`,
applied only by `./install.sh --with-overrides`.
`main` is the original macOS setup.

## Deploying

`./install.sh` (`--dry-run` to preview, `--no-tools` to skip network steps, `--with-overrides` /
`--without-overrides` to add or remove the opt-in layer). It uses GNU Stow: `base/`, `zsh/` and
`overrides/` are packages mirroring `$HOME`, stowed with `--no-folding --restow` so every file is its
own relative symlink and app directories stay real. Before stowing it moves anything in the way to
`~/.local/state/dotfiles/backup/` and drops stale links into the repo; afterwards it appends one marked
block each to `~/.bashrc`, `kitty.conf` and `tmux.conf`. No build step. Always run `--dry-run` first
after changing the installer, and test override on/off with a throwaway `HOME` (also set
`XDG_STATE_HOME` inside it, or backups land in the real one).

## Rules for changes

- **Additive vs override.** Ask: does this change how an existing key, option, command, alias, look or
  plugin behaves? If yes it is an override: put it under `overrides/` at its `$HOME`-relative path.
  If it only adds something new, it goes under `base/`. A new file needs no installer change.

- **Read Omarchy's side first.** Defaults live in `/usr/share/omarchy/` (read-only, never edit) and the
  user-editable copies in `~/.config`. Check `default/bash/{aliases,functions}` before adding an alias or
  function: Omarchy already uses `c t a d r h n g ga gd ls lt ff eff cd open`, among others. The zsh
  side is `/usr/share/omarchy-zsh/shell/` (same names). `c=clear` in `zsh/.zshrc` is a deliberate exception.
- **Shell layer runs in both shells.** `shell.bash` is sourced by bash and by zsh (`emulate sh`), so keep
  it portable. Opt-in shell overrides follow the same split: `overrides.sh` (portable, loaded by both),
  `overrides.bash` (`bind`, readline; sourced from `shell.bash`) and `overrides.zsh` (`bindkey`, zle;
  sourced from `~/.zshrc`).
- **No hardcoded colors anywhere.** Every app must follow the active Omarchy theme. Use ANSI color
  names (fzf, lazygit, starship), LazyVim's `auto` lualine theme, or, when an app needs real hex
  values (yazi), an Omarchy template: `base/.config/omarchy/themed/<file>.tpl` uses `{{ accent }}`,
  `{{ mix background accent 30% }}` etc. from the theme's `colors.toml`, is rendered on every
  `omarchy theme set`, and a `hooks/theme-set.d/` script copies the result into the app's config.
  Test a template against other themes with a throwaway `HOME` and `omarchy-theme-set-templates`,
  never by switching the live theme. `omarchy theme refresh` re-renders without changing the wallpaper.
- **Never export** `EDITOR`, `BROWSER`, `TERMINAL`, `PAGER`, `LC_ALL`, or set `clipboard=unnamedplus` in nvim.
- **mise**: only tools Omarchy does not install through pacman, in `conf.d/dotfiles.toml`.
- Files here are symlinked, so edit them in the repo, not under `~/.config`. Keep `.gitignore` files
  out of packages (stow skips them).

## Layout

```
install.sh                         idempotent installer (stow + include blocks + tools)
base/.config/                      ADDITIVE, always stowed
  dotfiles/shell.bash              new functions/aliases, sourced by ~/.zshrc and the end of ~/.bashrc
  kitty/dotfiles.conf              included by kitty.conf
  tmux/dotfiles.conf               sourced by tmux.conf, declares tpm plugins
  mise/conf.d/dotfiles.toml        extra mise tools
  yazi/                            yazi config (Omarchy has none); theme.toml is generated, not stored
  omarchy/backgrounds/tokyo-night/ user wallpapers for that theme slug
  omarchy/themed/*.tpl             theme templates (yazi); hooks/theme-set.d/ copies the output into place
  nvim/                            overlay on Omarchy's LazyVim (see below)
zsh/                               .zshrc (omarchy-zsh + shell.bash), .zshenv (Omarchy env bootstrap)
overrides/.config/                 OPT-IN, only with --with-overrides
  dotfiles/overrides.{sh,bash,zsh} kitty/dotfiles-overrides.conf tmux/dotfiles-overrides.conf
  starship.toml lazygit/config.yml
  nvim/                            mirrors ~/.config/nvim: dotfiles/overrides/*, plugin specs, ftplugin
```

### Neovim overlay

Symlinked file by file into `~/.config/nvim`, so Omarchy's directory (and `lua/plugins/theme.lua`, a
symlink Omarchy rewrites) stays untouched.

- `plugin/dotfiles.lua` loads `lua/dotfiles/keymaps.lua` on `VeryLazy` (after LazyVim registers its
  own) and, only if present, `dotfiles.overrides.{options,keymaps,autocmds}`.
- `lua/plugins/*.lua` here are standalone additions. A spec that tunes a LazyVim plugin's `opts`
  (lists append, tables deep-merge) is an override, so it lives in `overrides/.config/nvim/lua/plugins/`.
- Default keymaps may only use keys that are free in Neovim and LazyVim. Redefining a builtin key
  (`J`, `n`, `-`, `gi`, `gt`, arrows, ...) is an override.
- Do not put a personal mapping on `<leader>` + `s d x f b q g c`: LazyVim uses those as menu prefixes.
  See `SHORTCUTS.md` for the ones already relocated.
- Do not `import` LazyVim extras from `lua/plugins/`: LazyVim rejects it. Inline the spec instead.
- Style: double quotes, 2 spaces, 120 columns (matches Omarchy's `stylua.toml`).

### Verifying nvim changes without touching the live config

Copy `~/.config/nvim` and `~/.local/share/nvim` into a scratch dir, symlink the overlay in, point
`XDG_CONFIG_HOME` / `XDG_DATA_HOME` / `XDG_STATE_HOME` / `XDG_CACHE_HOME` at it, then run
`nvim --headless "+Lazy! sync" +qa`. Headless has no UI, so `VeryLazy` never fires: trigger it with
`vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })` before checking keymaps.
