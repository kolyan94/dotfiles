-- Neovim Configuration
-- Optimized for Swift, C/C++, Python, and Markdown development

-- Load core configuration
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins with performance optimizations
require('lazy').setup({
  -- Import all plugin configurations
  { import = 'plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
  defaults = {
    lazy = true, -- Make all plugins lazy by default
    version = false, -- Don't use version constraints for faster loading
  },
  performance = {
    cache = {
      enabled = true,
      path = vim.fn.stdpath('cache') .. '/lazy/cache',
      -- Try to load cache from multiple paths
      disable_events = { 'VimEnter', 'BufReadPre' },
    },
    reset_packpath = true, -- Reset packpath to improve startup time
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  checker = {
    enabled = true,
    frequency = 3600, -- Check for updates every hour instead of constantly
  },
  change_detection = {
    enabled = true,
    notify = false, -- Don't notify about config changes
  },
})