# Neovim shortcuts (Omarchy LazyVim + personal layer)

One Neovim: Omarchy's LazyVim is the base and this repo adds a layer on top
(`plugin/dotfiles.lua`, `lua/dotfiles/keymaps.lua`, extra specs in `lua/plugins/`).
By default it only adds keys that are free; nothing LazyVim or Neovim already does is changed.
Press `<space>` and wait: which-key lists everything, including LazyVim's own keys.
Rows marked **(opt-in)** exist only after `./install.sh --with-overrides`.

## Added by default

| Key | Action |
| --- | --- |
| `<leader>p` (visual) | Paste without yanking |
| `<leader>y` / `<leader>Y` | Yank to system clipboard |
| `<leader>fo` / `:Oil` | Oil file explorer (float / parent directory) |
| `gsa` `gsd` `gsr` ... | Surround (mini.surround) |
| `F5` `F1` `F2` `F3` `F7` | Debug: continue, into, over, out, toggle UI |
| `<leader>hs/hr/hp/hb/hd/...` | Git hunk actions (gitsigns). Jump between hunks with LazyVim's `]h` / `[h` |
| `<leader>sf` `s.` `s/` `sn` | Find files, recent, grep open buffers, nvim config |
| `<leader><leader>` | Buffers |
| `<leader>rn` | LSP rename |
| `<leader>ir` `ib` `id` / `:XtoolNew` | iOS via xtool: build + run on iPhone, build, list devices / new project |
| `:PlaydateRun` / `:PlaydateLuarc` | Playdate: build + open simulator / write `.luarc.json` for lua_ls |

## Opt-in (`--with-overrides`)

| Key / behavior | What it does |
| --- | --- |
| `jk` (insert) | Escape |
| `J` | Join lines, keep cursor |
| `Ctrl-d` / `Ctrl-u`, `n` / `N` | Centered scrolling / search |
| `J` / `K` (visual) | Move selection down / up |
| `Alt-h/j/k/l` | Move line or selection (mini.move) |
| `-` | Oil: open parent directory |
| `gi` / `gt` | LSP implementation / type definition pickers |
| `Ctrl-n` (+ `Ctrl-x`, `Ctrl-p`) | Multi-cursor (visual-multi) |
| `zR` / `zM` | Open / close all folds (ufo) |
| Arrow keys | Disabled (hardtime + keymap) |
| options | relative numbers, format on save (not C/C++), scrolloff 10, no swap files, `inccommand=split` |
| look | slanted bufferline, flat lualine + LSP name, `+ ~ _` gitsigns, markview, bqf, precognition |
| formatters | isort/black, clang-format, stylua, prettier via conform |

## Moved, because LazyVim uses the old key as a menu prefix

| Was | Now | Why |
| --- | --- | --- |
| `<leader>d` delete without yanking | `<leader>D` | `<leader>d` is LazyVim's debug menu |
| `<leader>s` replace word under cursor | `<leader>rw` | `<leader>s` is LazyVim's search menu |
| `<leader>x` make file executable | `<leader>cx` | `<leader>x` is diagnostics/quickfix |
| `<leader>f` format buffer | `<leader>cf` | `<leader>f` is LazyVim's file menu (`<leader>ff` would lag) |
| `<leader>b` / `<leader>B` breakpoint | `<leader>db` / `<leader>dB` | `<leader>b` is the buffer menu |
| `<leader>-` Oil float | `<leader>fo` | `<leader>-` is LazyVim's split below |
| `<leader>q` diagnostic loclist | `<leader>xl` | `<leader>q` is quit/session |
| `<leader>lg`, `Ctrl-\`, `<leader>gg` (toggleterm) | `<leader>gg` lazygit, `Ctrl-/` terminal | snacks replaces toggleterm and lazygit.nvim |
| mini.surround `sa` `sd` `sr` | `gsa` `gsd` `gsr` | stock `s*` would shadow flash's `s` |
| `<leader>sr` spectre, `<leader>sR` resume | `<leader>sr` grug-far replace, `<leader>sR` resume | grug-far replaces spectre |
| `<leader>ds` / `<leader>ws` symbols | `<leader>ss` / `<leader>sS` | LazyVim symbol pickers |
| `]c` / `[c` next/previous git change | `]h` / `[h` | `]c` / `[c` are LazyVim's next/previous class (treesitter textobjects) |

## Replaced by LazyVim equivalents (plugin removed)

Telescope -> snacks picker; alpha -> snacks dashboard; noice/notify -> LazyVim's noice +
snacks notifier; indent-blankline -> snacks indent; nvim-autopairs -> mini.pairs;
persistence, todo-comments, flash, gitsigns, conform, bufferline, lualine, which-key,
blink.cmp, mason, treesitter -> LazyVim's own (tuned in `lua/plugins/`);
toggleterm / lazygit.nvim -> snacks terminal / lazygit; nvim-spectre -> grug-far;
xcodebuild.nvim -> removed (macOS only); `lua/plugins/xtool.lua` replaces it on Linux.

## Deliberately not carried over

`clipboard = "unnamedplus"` (would bypass Omarchy's OSC 52 clipboard), the
`regexpengine=1` / `completeopt` tweaks, hardcoded solarized bufferline colors and the
hardcoded lualine theme (both would ignore `omarchy theme set`).
