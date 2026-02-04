-- Obsidian integration
return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/Documents/Obsidian/Zettel/*.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/Documents/Obsidian/Zettel/*.md',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'saghen/blink.cmp',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('obsidian').setup {
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
    }
  end,
}
