# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this is

One branch of personal dotfiles for two kinds of machines, deployed with GNU Stow by `./install.sh`:

- **macOS** (`common/` + `common-overrides/` + `macos/`): the original setup. zsh with zinit, kitty,
  tmux, Homebrew/mise, a standalone kickstart-style Neovim (single quotes, 160 columns). Its own
  colors (Tokyo Night hex) are fine there.
- **Omarchy** (`common/` + `omarchy/`, plus `shell-overrides/` with `--with-shell-overrides`, or that
  and `common-overrides/` + `omarchy-overrides/` with `--with-overrides`): Arch + Hyprland + zsh via omarchy-zsh (bash still supported) + kitty + tmux +
  LazyVim. **Omarchy is the base; this is an overlay.** By default it may only ADD. It must never
  replace or edit files Omarchy owns, and must not change any existing Omarchy/LazyVim/system default.

Where a change goes:
- Same file, same behavior on both systems → `common/`. If on Omarchy it would change a default →
  `common-overrides/` (always on for macOS, opt-in on Omarchy). Edit these knowing both systems load them.
- Only macOS → `macos/`. Only Omarchy → `omarchy/` (additive) or `omarchy-overrides/` (changes a default; shell aliases and
  key bindings that change a default go in `shell-overrides/`).
- Never keep two copies of one path in packages that are stowed together (stow would conflict):
  `common*` must not share a path with `macos/` or `omarchy*`.

## Deploying

`./install.sh` (`--dry-run` to preview, `--no-tools` to skip network steps, `--os macos|omarchy` to
force the platform, `--with-overrides` / `--without-overrides` for the Omarchy opt-in layers, `--with-shell-overrides` /
`--without-shell-overrides` for just the shell one). Packages
are stowed with `--no-folding --restow`, so every file is its own relative symlink and app directories
stay real. Before stowing it drops links into the repo that no package owns (older layouts: macOS
`stow .` with folded dirs, Omarchy's old `base/ zsh/ overrides/`), and moves anything else in the way
to `~/.local/state/dotfiles/backup/`. On Omarchy it then appends one marked block each to `~/.bashrc`,
`kitty.conf` and `tmux.conf`. No build step. The installer must keep running on macOS's bash 3.2 and
BSD tools (no `realpath -m`, `find -xtype`, `grep -P`, `mapfile`, `${x,,}`). Always run `--dry-run`
first after changing it, and test both platforms with a throwaway `HOME` (also set `XDG_STATE_HOME`
inside it, or backups land in the real one): `--os macos` works on Linux too.

## Rules for changes

- **Additive vs override.** Ask: does this change how an existing key, option, command, alias, look or
  plugin behaves? If yes it is an override: put it under `omarchy-overrides/` (or `common-overrides/`)
  at its `$HOME`-relative path. If it only adds something new, it goes under `omarchy/` (or `common/`). A new file needs no installer change.

- **Read Omarchy's side first.** Defaults live in `/usr/share/omarchy/` (read-only, never edit) and the
  user-editable copies in `~/.config`. Check `default/bash/{aliases,functions}` before adding an alias or
  function: Omarchy already uses `c t a d r h n g ga gd ls lt ff eff cd open`, among others. The zsh
  side is `/usr/share/omarchy-zsh/shell/` (same names). `c=clear` in `omarchy/.zshrc` is a deliberate exception.
- **Shell layer runs in both shells.** `shell.bash` is sourced by bash and by zsh (`emulate sh`), so keep
  it portable. Opt-in shell overrides (`shell-overrides/`) follow the same split: `overrides.sh` (portable, loaded by both),
  `overrides.bash` (`bind`, readline; sourced from `shell.bash`) and `overrides.zsh` (`bindkey`, zle;
  sourced from `~/.zshrc`).
- **No hardcoded colors anywhere.** Every app must follow the active Omarchy theme. Use ANSI color
  names (fzf, lazygit, starship), LazyVim's `auto` lualine theme, or, when an app needs real hex
  values (yazi), an Omarchy template: `omarchy/.config/omarchy/themed/<file>.tpl` uses `{{ accent }}`,
  `{{ mix background accent 30% }}` etc. from the theme's `colors.toml`, is rendered on every
  `omarchy theme set`, and a `hooks/theme-set.d/` script copies the result into the app's config.
  Test a template against other themes with a throwaway `HOME` and `omarchy-theme-set-templates`,
  never by switching the live theme. `omarchy theme refresh` re-renders without changing the wallpaper.
- **Never export** `EDITOR`, `BROWSER`, `TERMINAL`, `PAGER`, `LC_ALL`, or set `clipboard=unnamedplus` in nvim.
- **mise** (Omarchy): only tools Omarchy does not install through pacman, in `omarchy/.config/mise/conf.d/dotfiles.toml`.
- **Python** must stay the same on both systems: the shared parts are in `common/`; basedpyright + ruff
  are configured in each `lspconfig.lua` (LazyVim `opts.servers` / macOS `servers` table), formatters in
  each `conform.lua`, debugpy in each `dap.lua`, all through `require("dotfiles.python")`.
- Files here are symlinked, so edit them in the repo, not under `~/.config`. Keep `.gitignore` files
  out of packages (stow skips them).

## Layout

```
install.sh                         idempotent installer for both platforms
.stow-local-ignore                 makes a stray `stow .` from the root a no-op
common/.config/                    every machine: dotfiles/python.sh (sourced by both .zshrc files and
                                   shell.bash), nvim lua/dotfiles/python.lua (venv lookup used by the
                                   LSP/DAP/neotest setups of both configs) + plugins/python.lua
                                   (venv-selector, neotest), yazi (init/keymap/yazi.toml), vim-be-good
common-overrides/.config/          macOS always, Omarchy opt-in: starship.toml, nvim hardtime bqf
                                   precognition vim-sleuth visual-multi, ftplugin/json.lua
macos/                             .zshrc, .config/{alias,kitty,tmux,mise,lazygit,zsh,backgrounds},
                                   yazi theme/flavors/plugins/package.toml, nvim (standalone config)
omarchy/                           .zshrc (omarchy-zsh + shell.bash), .zshenv, .local/bin, and .config/:
  dotfiles/shell.bash              new functions/aliases, sourced by ~/.zshrc and the end of ~/.bashrc
  kitty/dotfiles.conf              included by kitty.conf
  tmux/dotfiles.conf               sourced by tmux.conf, declares tpm plugins
  mise/conf.d/dotfiles.toml        extra mise tools
  yazi/package.toml                yazi plugins; theme.toml is generated, not stored
  omarchy/backgrounds/tokyo-night/ user wallpapers for that theme slug
  omarchy/themed/*.tpl             theme templates (yazi); hooks/theme-set.d/ copies the output into place
  nvim/                            overlay on Omarchy's LazyVim (see below)
shell-overrides/.config/dotfiles/  Omarchy OPT-IN shell: overrides.{sh,bash,zsh} (--with-shell-overrides or --with-overrides)
omarchy-overrides/.config/         Omarchy OPT-IN, only with --with-overrides
  kitty/dotfiles-overrides.conf tmux/dotfiles-overrides.conf
  lazygit/config.yml
  nvim/                            mirrors ~/.config/nvim: dotfiles/overrides/*, plugin specs
```

### Neovim overlay

Symlinked file by file into `~/.config/nvim`, so Omarchy's directory (and `lua/plugins/theme.lua`, a
symlink Omarchy rewrites) stays untouched.

- `plugin/dotfiles.lua` loads `lua/dotfiles/keymaps.lua` on `VeryLazy` (after LazyVim registers its
  own) and, only if present, `dotfiles.overrides.{options,keymaps,autocmds}`.
- `lua/plugins/*.lua` here are standalone additions. A spec that tunes a LazyVim plugin's `opts`
  (lists append, tables deep-merge) is an override, so it lives in `omarchy-overrides/.config/nvim/lua/plugins/`.
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
