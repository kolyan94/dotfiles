# dotfiles (Omarchy branch)

Personal config for an [Omarchy](https://omarchy.org) (Arch + Hyprland) machine, ported from a
macOS setup. `main` is the macOS original. Managed with [GNU Stow](https://www.gnu.org/software/stow/):
`base/`, `zsh/` and `overrides/` are packages that each mirror `$HOME`.

**Omarchy stays the base.** By default this branch only *adds* things: new commands, keys on
unused keys, new plugins and tools. It changes no Omarchy or LazyVim default, and edits no file
Omarchy owns, so `omarchy update` and `omarchy theme set` keep working. Anything that would
override a default lives in `overrides/` and is applied only when you ask for it.

```bash
sudo pacman -S stow omarchy-zsh   # prerequisites
git clone -b omarchy https://github.com/kolyan94/dotfiles && cd dotfiles
./install.sh --dry-run            # preview
./install.sh                      # stow base + zsh (additive)
./install.sh --with-overrides     # also stow overrides/ (opt-in)
./install.sh --without-overrides  # take the overrides out again
```

Stow runs with `--no-folding`, so every file is its own symlink and directories such as
`~/.config/nvim` stay real and Omarchy's. Anything a link would replace is backed up first to
`~/.local/state/dotfiles/backup/<timestamp>/`. To make zsh the login shell: `chsh -s /usr/bin/zsh`.

## Shell: zsh

`zsh/.zshrc` loads [omarchy-zsh](https://github.com/omacom/omarchy-zsh) (Omarchy's official zsh
config: same aliases, functions, starship, zoxide, mise and fzf setup as its bash) and then the
shared `shell.bash` layer below. Use it instead of `omarchy-setup-zsh`, which would overwrite
`~/.bashrc`. `zsh/.zshenv` sets `OMARCHY_PATH`/`PATH` for every zsh. Bash keeps working as before.
`c` is `clear` here (Omarchy makes it `opencode`).

## Added by default

| Path (in `base/`) | What it adds | How it hooks in |
| --- | --- | --- |
| `.config/dotfiles/shell.bash` | `y` (yazi cd), `cpp`, `cpg`, `mvg`, `mkdirg`, `runfree`, `random_bars`, `vi`/`vim` -> nvim when no vi/vim is installed, `serial` (fzf port picker + tio / `pio device monitor`), `pdrun` (Playdate build + simulator), aliases `q lg svi vis help iplocal ipexternal` | sourced by `~/.zshrc`; one block appended to `~/.bashrc` |
| `.config/nvim/` | keys on free `<leader>` slots, extra LSP servers and parsers, oil, dap, obsidian, mini.surround (`gs*`), vim-be-good | per-file links into `~/.config/nvim` |
| `.config/kitty/dotfiles.conf` | `ctrl+alt+enter` new window in same dir | `include` appended to `kitty.conf` |
| `.config/tmux/dotfiles.conf` | tpm, floax (`prefix F`), sessionx (`prefix O`) | `source-file` appended to `tmux.conf` |
| `.config/mise/conf.d/dotfiles.toml` | yazi, tlrc, rclone; embedded: arduino-cli, uv, PlatformIO (`pio`), esptool | mise merges `conf.d/` |
| `.config/yazi/` | file manager config and plugins | per-file links (Omarchy has no yazi config) |
| `.config/omarchy/themed/yazi-theme.toml.tpl` + `hooks/theme-set.d/dotfiles-yazi` | yazi colors that follow the active Omarchy theme | template Omarchy renders on every theme change; the hook copies the result to `~/.config/yazi/theme.toml` |
| `.config/omarchy/backgrounds/tokyo-night/` | 31 wallpapers | `omarchy theme bg next` picks them up |

## Opt-in overrides (`--with-overrides`)

These change existing behavior or look, so they are off by default.

| Path (in `overrides/.config/`) | What it changes |
| --- | --- |
| `dotfiles/overrides.{sh,bash,zsh}` | vi mode with cursor shapes (`.bash` / `.zsh`); shared by both shells (`.sh`): `cp -i`/`mv -i`/`rm -i`/`mkdir -p`/`grep --color` aliases, `cat`->bat, `top`->btop, `vi`/`vim`->nvim, fzf layout |
| `kitty/dotfiles-overrides.conf` | beam cursor with trail, window padding |
| `tmux/dotfiles-overrides.conf` | Shift-arrow / Alt-Shift-h,l window keys, cwd-preserving `"` and `%` splits |
| `starship.toml` | replaces Omarchy's prompt |
| `lazygit/config.yml` | lazygit branch colors and nerd-font icons, with borders in terminal (ANSI) colors |
| `nvim/` | relative numbers, format on save, `J`/`n`/`N`/`Ctrl-d`/`Ctrl-u`/`jk`/arrow-key changes, hardtime, ufo, precognition, markview, bqf, vim-sleuth, visual-multi, mini.move, LazyVim look tweaks (bufferline, lualine, gitsigns, flash), formatters |

## Themes

Everything follows the active Omarchy theme; nothing carries a hardcoded palette.

| App | How it follows |
| --- | --- |
| kitty, tmux, btop, ... | Omarchy's own theming (untouched) |
| Neovim | Omarchy's `theme.lua` symlink and hot-reload (untouched); lualine uses `auto` |
| yazi | template rendered from the theme's `colors.toml` on every `omarchy theme set` |
| fzf, lazygit, starship | ANSI color names, resolved through the terminal palette |

The yazi template sets no background, so terminal transparency shows through. Yazi's own
built-in theme is used if a theme ships no `colors.toml`. Re-render after editing the template
with `omarchy theme refresh` (it does not change the wallpaper).

## Neovim: one config, not two

Omarchy's LazyVim is the base and nothing it ships is edited. `plugin/dotfiles.lua` loads
`lua/dotfiles/keymaps.lua` after LazyVim's own keymaps, and `lua/plugins/*.lua` adds plugins.
The override layer (`lua/dotfiles/overrides/*`, extra specs) exists only when installed with
`--with-overrides`. Theme hot-reload, transparency and the OSC 52 clipboard are untouched.
See [`base/.config/nvim/SHORTCUTS.md`](base/.config/nvim/SHORTCUTS.md).

## Removed from the macOS config

- **macOS zsh setup**: the old `.zshrc`, zinit and plugins, the zsh highlight theme, the unsourced 86 KB `.zsh_aliases` (zsh now comes from omarchy-zsh, see above).
- **macOS-only**: Homebrew paths, `xcodebuild.nvim` and the Xcode/`xcrun` LSP launcher, the Xcode lualine widget, `com.brave.Browser`.
- **Would fight Omarchy, so dropped even from overrides**: kitty colors/font/opacity (Omarchy themes kitty), tokyo-night-tmux and tmux-sensible, `EDITOR`/`BROWSER`/`TERMINAL`/`PAGER` exports, aliases that clash with Omarchy's, mise entries that duplicate pacman packages, `clipboard=unnamedplus`.
- **Duplicated by LazyVim**: telescope, alpha, noice, notify, autopairs, indent-blankline, persistence, toggleterm, lazygit.nvim, spectre.

## Notes

- After `omarchy refresh kitty|tmux` or a reset `~/.bashrc`, re-run `./install.sh`.
- Yazi's code-preview highlighting uses its built-in syntax theme, not a Tokyo Night one.
- To restore Omarchy's stock prompt after removing overrides: `omarchy refresh config starship.toml`.
- Yazi previews want `7zip` and `chafa` (optional): `omarchy pkg add 7zip chafa`.
- Embedded (`lua/plugins/embedded.lua`): `.ino` sketches get arduino-language-server, which needs
  `arduino-cli config init`, a core (`arduino-cli core install arduino:avr` / `esp32:esp32`) and a
  `sketch.yaml` (`arduino-cli board attach -b <fqbn> x.ino`). PlatformIO projects use clangd after
  `pio run -t compiledb`. Serial ports need `sudo usermod -aG uucp $USER` (then log out and in).
- Playdate: `yay -S playdate-sdk`, then `:PlaydateLuarc` in a project writes `.luarc.json` for lua_ls,
  and `:PlaydateRun` / `pdrun` build `source/` and open the simulator. API types: clone
  [playdate-luacats](https://github.com/notpeter/playdate-luacats) to `~/.local/share/playdate-luacats`.
- The Obsidian vault path in `lua/plugins/obsidian.lua` is `~/Documents/Obsidian/Zettel`.

## License

[MIT](LICENSE)
