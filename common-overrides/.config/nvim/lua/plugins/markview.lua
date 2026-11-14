-- Enhanced markdown rendering. Icons come from mini.icons (LazyVim mocks
-- nvim-web-devicons with it), so no devicons dependency is declared.
return {
  "OXY2DEV/markview.nvim",
  lazy = true,
  ft = { "markdown", "norg", "rmd", "org" },
  config = function()
    local presets = require("markview.presets")
    require("markview").setup({
      markdown = {
        headings = presets.headings.simple,
        tables = presets.tables.rounded,
        horizontal_rules = presets.horizontal_rules.dashed,
      },
      preview = {
        icon_provider = "devicons",
        filetypes = { "markdown", "norg", "rmd", "org" },
        ignore_buftypes = {},
      },
    })
  end,
}
