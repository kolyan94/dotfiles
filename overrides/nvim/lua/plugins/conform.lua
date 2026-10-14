-- LazyVim ships conform + format-on-save (enabled via vim.g.autoformat in
-- dotfiles/options.lua). Formatters are installed by mason, see lspconfig.lua.
-- Format by hand with <leader>cf.
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "isort", "black" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      lua = { "stylua" },
      markdown = { "prettier" },
      -- swift = { "swiftformat" }, -- install swiftformat first
    },
  },
}
