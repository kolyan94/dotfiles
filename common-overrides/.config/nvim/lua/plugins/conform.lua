-- LazyVim ships conform + format-on-save (enabled via vim.g.autoformat in
-- dotfiles/options.lua). Formatters are installed by mason, see lspconfig.lua (ruff
-- comes with its LSP server).
-- Format by hand with <leader>cf.
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "ruff_organize_imports", "ruff_format" }, -- black-compatible output
      c = { "clang_format" },
      cpp = { "clang_format" },
      lua = { "stylua" },
      markdown = { "prettier" },
      -- swift = { "swiftformat" }, -- install swiftformat first
    },
  },
}
