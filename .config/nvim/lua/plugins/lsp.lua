-- LSP configuration for Swift, C/C++, Python, Markdown
return {
  -- LSP Support
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs to stdpath
      {
        'williamboman/mason.nvim',
        lazy = false, -- Don't lazy load Mason
        priority = 100, -- Load Mason early
        opts = {},
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },

      -- Lua development for Neovim config
      { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
    },
    config = function()
      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Diagnostic navigation
          map('[d', vim.diagnostic.goto_prev, 'Previous [D]iagnostic')
          map(']d', vim.diagnostic.goto_next, 'Next [D]iagnostic')

          -- Toggle inlay hints
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint or 'textDocument/inlayHint') then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Configure diagnostics
      vim.diagnostic.config {
        virtual_text = {
          prefix = '●',
          spacing = 4,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = false,
          style = 'minimal',
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      }

      -- LSP servers configuration
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        -- C/C++
        clangd = {
          cmd = { 'clangd', '--background-index', '--query-driver=**', '-j=12' },
        },

        -- Python
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

        -- JavaScript/TypeScript
        ts_ls = {},

        -- HTML/CSS
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        cssls = {},

        -- JSON
        jsonls = {},

        -- Bash
        bashls = {},

        -- Markdown
        marksman = {},

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
      }

      -- Setup Mason tool installer
      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, {
        'stylua',
        'swiftlint',
        'black',
        'isort',
        'clang-format',
        'prettier',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Setup Mason LSP config
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- Swift LSP (manual setup since it comes with Xcode)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'swift', 'objc', 'objcpp' },
        callback = function(args)
          vim.lsp.start {
            name = 'sourcekit-lsp',
            cmd = { 'sourcekit-lsp' },
            root_dir = vim.fs.root(args.buf, {
              'Package.swift',
              '*.xcodeproj',
              '*.xcworkspace',
              'buildServer.json',
            }) or vim.fn.getcwd(),
            capabilities = capabilities,
          }
        end,
      })
    end,
  },

  -- Autocompletion
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        config = function()
          require('luasnip').setup()
        end,
      },
    },
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          buffer = { score_offset = -3 },
        },
      },
      snippets = { preset = 'luasnip' },
      signature = { enabled = true },
    },
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable auto-format for C/C++
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        python = { 'isort', 'black' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        lua = { 'stylua' },
        markdown = { 'prettier' },
        -- swift = { 'swiftformat' }, -- Uncomment after: brew install swiftformat
      },
    },
  },
}

