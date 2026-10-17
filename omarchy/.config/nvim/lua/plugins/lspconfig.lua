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
        -- Python: basedpyright for types/completion/navigation, ruff for lint, fixes, import
        -- sorting and formatting. The interpreter comes from the project's venv (dotfiles.python),
        -- or from :VenvSelect (<leader>cv), which restarts the servers with the chosen one.
        basedpyright = {
          before_init = function(_, config)
            config.settings = config.settings or {}
            config.settings.python = vim.tbl_extend("force", config.settings.python or {}, {
              pythonPath = require("dotfiles.python").python(config.root_dir),
            })
          end,
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard", -- the default "recommended" flags almost every line
                diagnosticMode = "openFilesOnly",
                autoImportCompletions = true,
              },
            },
          },
        },
        ruff = {
          -- hover comes from basedpyright; ruff's only shows rule docs
          on_attach = function(client) client.server_capabilities.hoverProvider = false end,
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {} } })
              end,
              desc = "Organize Imports",
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
    opts = { ensure_installed = { "debugpy", "clang-format", "prettier" } },
  },
}
