-- LazyVim owns LSP setup (mason + vim.lsp.config). This only adds servers, tools
-- and one free key on top. Diagnostic float style and gi/gt are opt-in (overrides).
-- Dropped: the Xcode/xcrun sourcekit-lsp launcher (macOS only), fidget (noice
-- shows LSP progress), mason-tool-installer (LazyVim's mason handles it), the
-- lua_ls block (LazyVim + lazydev already configure it).
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
          },
        },
        -- clangd is already on this system (pacman), so skip mason's copy
        clangd = {
          mason = false,
          cmd = { "clangd", "--background-index", "--query-driver=**" },
        },
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = { enabled = false },
                mccabe = { enabled = false },
                pyflakes = { enabled = true },
                rope_autoimport = { enabled = true },
                rope_completion = { enabled = true },
              },
            },
          },
        },
        ts_ls = {},
        html = { filetypes = { "html", "twig", "hbs" } },
        cssls = {},
        jsonls = {},
        bashls = {},
        marksman = {},
        -- Swift on Linux: sourcekit-lsp ships with the Swift toolchain, not mason.
        -- Only turned on when the binary exists, and limited to Swift/ObjC so it
        -- never competes with clangd for C/C++.
        sourcekit = {
          mason = false,
          enabled = vim.fn.executable("sourcekit-lsp") == 1,
          filetypes = { "swift", "objc", "objcpp" },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "black", "isort", "clang-format", "prettier" } },
  },
}
