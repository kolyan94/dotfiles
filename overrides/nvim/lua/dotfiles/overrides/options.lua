-- OPT-IN (installed by `./install.sh --with-overrides`): changes LazyVim/Omarchy default options.
-- Personal options. LazyVim already sets: number, mouse, showmode, undofile,
-- ignorecase/smartcase, signcolumn, splitright/splitbelow, cursorline, confirm,
-- timeoutlen and the leader key, so those are not repeated here.
--
-- Intentionally NOT set:
--   clipboard   Omarchy's config.remote_clipboard routes yanks through OSC 52 so
--               they reach tmux/SSH clients; `unnamedplus` would bypass it.
--   regexpengine=1, complete, completeopt   old-engine / completion tweaks that
--               fight blink.cmp and modern Neovim.
--   vim.loader.enable()   lazy.nvim already enables the module cache.
local opt = vim.opt

opt.relativenumber = true -- Omarchy sets false; this is a personal preference
opt.breakindent = true
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split"
opt.scrolloff = 10
opt.updatetime = 250

-- No swap/backup files, no forced fsync
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.fsync = false
opt.synmaxcol = 240

-- Format on save (Omarchy turns this off). C/C++ is excluded in autocmds.lua.
vim.g.autoformat = true
