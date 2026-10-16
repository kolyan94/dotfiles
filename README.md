# dotfiles

Personal config for macOS and [Omarchy](https://omarchy.org) (Arch + Hyprland) machines, from one
branch. Managed with [GNU Stow](https://www.gnu.org/software/stow/): every top-level package below
mirrors `$HOME`, and `./install.sh` stows the ones for the machine it runs on.

| Package | What it holds | macOS | Omarchy |
| --- | --- | --- | --- |
| `common/` | identical on every machine and on by default everywhere (yazi `init.lua`/`keymap.toml`/`yazi.toml`, vim-be-good) | always | always |
| `common-overrides/` | identical everywhere, but on Omarchy it changes a default (starship prompt, hardtime, bqf, precognition, vim-sleuth, visual-multi, json ftplugin) | always | `--with-overrides` |
| `macos/` | the macOS setup: zinit `.zshrc`, kitty, tmux, mise, standalone (kickstart-style) Neovim with xcodebuild, yazi theme and plugins | always | - |
| `omarchy/` | the Omarchy overlay: additive shell layer, zsh via omarchy-zsh, LazyVim overlay, theme templates | - | always |
| `shell-overrides/` | Omarchy opt-in shell layer: vi mode, `cp -i`/`rm -i`, `cat`->bat, `top`->btop, `vi`->nvim, fzf look | - | `--with-shell-overrides` or `--with-overrides` |
| `omarchy-overrides/` | Omarchy opt-in layer: kitty/tmux tweaks, lazygit, LazyVim look and behavior | - | `--with-overrides` |

A change to a `common*` file reaches every machine on the next `git pull` (the links point into the
repo), with no branch merges. Put a file in `common/` only when it is the same on both systems.

```bash
# macOS                           # Omarchy
brew install stow                 sudo pacman -S stow omarchy-zsh
git clone https://github.com/kolyan94/dotfiles && cd dotfiles
./install.sh --dry-run            # preview
./install.sh                      # stow this machine's packages
./install.sh --with-shell-overrides  # Omarchy only: opt-in shell aliases + vi mode
./install.sh --with-overrides     # Omarchy only: every opt-in layer (shell, prompt, nvim, ...)
./install.sh --without-overrides  # Omarchy only: take them out again (--without-shell-overrides: shell only)
```

Stow runs with `--no-folding`, so every file is its own symlink and directories such as
`~/.config/nvim` stay real. Anything a link would replace is backed up first to
`~/.local/state/dotfiles/backup/<timestamp>/`. The installer runs on macOS's bash 3.2 and BSD tools.

**Moving a Mac from the old `stow .` layout:** `git pull`, then `./install.sh --dry-run` and
`./install.sh`. It drops the old links (including folded ones like `~/.config/nvim -> repo`), stows the
new packages and moves runtime files the old layout made apps write into the repo (tpm plugins,
`lazy-lock.json`) to where they belong. Every config file resolves to the same content as before. A
root `.stow-local-ignore` makes a stray `stow .` a no-op.

# Omarchy

**Omarchy stays the base.** By default the Omarchy packages only *add* things: new commands, keys on
unused keys, new plugins and tools. They change no Omarchy or LazyVim default, and edit no file
Omarchy owns, so `omarchy update` and `omarchy theme set` keep working. Anything that would
override a default lives in `common-overrides/`, `shell-overrides/` or `omarchy-overrides/` and is applied only when you
ask for it. To make zsh the login shell: `chsh -s /usr/bin/zsh`, then reboot (logging out keeps the
old `$SHELL` in the systemd user session).

## Shell: zsh

`omarchy/.zshrc` loads [omarchy-zsh](https://github.com/omacom/omarchy-zsh) (Omarchy's official zsh
config: same aliases, functions, starship, zoxide, mise and fzf setup as its bash) and then the
shared `shell.bash` layer below. Use it instead of `omarchy-setup-zsh`, which would overwrite
`~/.bashrc`. `omarchy/.zshenv` sets `OMARCHY_PATH`/`PATH` for every zsh. Bash keeps working as before.
`c` is `clear` here (Omarchy makes it `opencode`).

## Added by default

| Path (in `omarchy/`, or `common/` for yazi and vim-be-good) | What it adds | How it hooks in |
| --- | --- | --- |
| `.config/dotfiles/shell.bash` | `y` (yazi cd), `cpp`, `cpg`, `mvg`, `mkdirg`, `runfree`, `vi`/`vim` -> nvim when no vi/vim is installed, `serial` (fzf port picker + tio / `pio device monitor`), `pdrun` (Playdate build + simulator), aliases `q lg svi help iplocal ipexternal ll tree pdf path`, git `gst gp gl glog`, systemd `failed scu jf ports`, PlatformIO `pb pu pum acli`, `preview` (fzf a file, open it) | sourced by `~/.zshrc`; one block appended to `~/.bashrc` |
| `.config/nvim/` | keys on free `<leader>` slots, extra LSP servers and parsers, oil, dap, obsidian, mini.surround (`gs*`), vim-be-good | per-file links into `~/.config/nvim` |
| `.config/kitty/dotfiles.conf` | `ctrl+alt+enter` new window in same dir | `include` appended to `kitty.conf` |
| `.config/tmux/dotfiles.conf` | tpm, floax (`prefix F`), sessionx (`prefix O`) | `source-file` appended to `tmux.conf` |
| `.config/mise/conf.d/dotfiles.toml` | yazi, tlrc, rclone; embedded: arduino-cli, uv, PlatformIO (`pio`), esptool | mise merges `conf.d/` |
| `.config/yazi/` | file manager config and plugins | per-file links (Omarchy has no yazi config) |
| `.config/omarchy/themed/yazi-theme.toml.tpl` + `hooks/theme-set.d/dotfiles-yazi` | yazi colors that follow the active Omarchy theme | template Omarchy renders on every theme change; the hook copies the result to `~/.config/yazi/theme.toml` |
| `.config/omarchy/backgrounds/tokyo-night/` | 31 wallpapers | `omarchy theme bg next` picks them up |

## Opt-in overrides (`--with-overrides`)

These change existing behavior or look, so they are off by default. `--with-shell-overrides` takes
only the shell row, without the prompt, terminal and Neovim changes.

| Path (in `omarchy-overrides/.config/`; the shell files are in `shell-overrides/`; starship, hardtime, bqf, precognition, vim-sleuth, visual-multi and the json ftplugin are in `common-overrides/`) | What it changes |
| --- | --- |
| `dotfiles/overrides.{sh,bash,zsh}` | vi mode with cursor shapes (`.bash` / `.zsh`); shared by both shells (`.sh`): `cp -i`/`mv -i`/`rm -i`/`mkdir -p`/`grep --color` aliases, drops Omarchy's `r`=rails, `cat`->bat, `top`->btop, `vi`/`vim`->nvim, fzf layout |
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
See [`omarchy/.config/nvim/SHORTCUTS.md`](omarchy/.config/nvim/SHORTCUTS.md).

## Left out of the Omarchy packages (still in `macos/`)

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

# macOS

`macos/` is the original setup, unchanged: `.zshrc` with zinit (syntax highlighting, completions,
autosuggestions, fzf-tab, zsh-vi-mode) and starship, kitty and tmux (tpm) configs, a mise
`config.toml`, Tokyo Night colors throughout, and a standalone Neovim built from kickstart.nvim
(telescope, toggleterm, xcodebuild.nvim, Xcode `sourcekit-lsp`). See `macos/.config/nvim/SHORTCUTS.md`.

## License

[MIT](LICENSE)
