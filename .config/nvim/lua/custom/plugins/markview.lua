return {
  'OXY2DEV/markview.nvim',
  lazy = false,

  -- For blink.cmp's completion
  -- source
  dependencies = {
    'saghen/blink.cmp',
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
      },
    }
  end,
}
