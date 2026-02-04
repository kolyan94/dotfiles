-- Enhanced markdown rendering
return {
  'OXY2DEV/markview.nvim',
  lazy = true,
  ft = { 'markdown', 'norg', 'rmd', 'org' },
  priority = 1000,
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
}
