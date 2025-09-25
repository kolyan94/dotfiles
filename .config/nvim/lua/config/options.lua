-- Neovim options configuration
-- See `:help vim.opt`

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital letters in search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Confirm dialog for unsaved changes
vim.opt.confirm = true

-- Performance optimizations
-- Note: lazyredraw is disabled due to Noice.nvim compatibility
vim.opt.regexpengine = 1 -- Use old regex engine for better performance
vim.opt.synmaxcol = 240 -- Limit syntax highlighting for long lines
vim.opt.maxmempattern = 20000 -- Increase memory for pattern matching

-- Faster file operations
vim.opt.fsync = false -- Don't force sync to disk
vim.opt.swapfile = false -- Disable swap files for better performance
vim.opt.backup = false -- Disable backup files
vim.opt.writebackup = false -- Don't create backup before overwriting

-- Faster completion
vim.opt.complete = 'kspell' -- Limit completion sources
vim.opt.completeopt = 'menuone,noselect' -- Better completion experience

-- Better startup time
vim.loader.enable() -- Enable faster Lua module loading (Neovim 0.9+)