-- Markdown support plugins
return {
  -- Treesitter for syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    priority = 500, -- Lower priority than markview
    opts = {
      ensure_installed = { 'swift', 'c', 'cpp', 'python', 'markdown', 'markdown_inline', 'lua', 'bash', 'vim', 'vimdoc', 'javascript', 'typescript' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    },
  },

  -- Enhanced markdown rendering
  {
    'OXY2DEV/markview.nvim',
    lazy = true,
    ft = { 'markdown', 'norg', 'rmd', 'org' },
    priority = 1000, -- Load before treesitter
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local presets = require 'markview.presets'
      require('markview').setup {
        markdown = {
          headings = presets.headings.simple,
          tables = presets.tables.rounded,
          horizontal_rules = presets.horizontal_rules.dashed,
        },
        preview = {
          icon_provider = 'devicons',
          filetypes = { 'markdown', 'norg', 'rmd', 'org' },
          ignore_buftypes = {},
        },
      }
    end,
  },

  -- Obsidian integration (only for vault files)
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/Documents/Obsidian/Zettel/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Documents/Obsidian/Zettel/*.md",
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'saghen/blink.cmp',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('obsidian').setup({
        workspaces = {
          {
            name = 'Zettel',
            path = '~/Documents/Obsidian/Zettel',
          },
        },
        completion = {
          blink = true,
          nvim_cmp = false,
          min_chars = 2,
        },
        legacy_commands = false,
      })
    end,
  },
}