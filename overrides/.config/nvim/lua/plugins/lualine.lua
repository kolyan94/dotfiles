-- LazyVim ships lualine with theme = "auto", which follows the Omarchy theme
-- (the old hardcoded 'tokyonight' theme would not). Keep the flat separators and
-- the active-LSP indicator.
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options.component_separators = { left = "", right = "" }
    opts.options.section_separators = { left = "", right = "" }
    table.insert(opts.sections.lualine_x, {
      function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        return next(clients) == nil and "No LSP" or ("LSP: " .. clients[1].name)
      end,
    })
  end,
}
