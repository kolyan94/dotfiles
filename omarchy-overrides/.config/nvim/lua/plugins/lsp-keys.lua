-- OPT-IN: gi / gt are Vim builtins (insert at last position / next tab), and the
-- diagnostic float restyle changes LazyVim's default look.
return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      float = { border = "rounded", source = "always", header = "", prefix = "" },
    },
    servers = {
      ["*"] = {
        keys = {
          { "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation", has = "implementation" },
          { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition", has = "typeDefinition" },
        },
      },
    },
  },
}
