-- LSP configuration
return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason.nvim', lazy = false, priority = 100, opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
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

    -- Configure diagnostics with better icons
    vim.diagnostic.config {
      virtual_text = {
        prefix = function(diagnostic)
          local icons = { '󰅚 ', '󰀪 ', '󰋽 ', '󰌶 ' }
          return icons[diagnostic.severity] or '●'
        end,
        spacing = 4,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      },
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
      clangd = {
        cmd = { 'clangd', '--background-index', '--query-driver=**', '-j=12' },
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
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      cssls = {},
      jsonls = {},
      bashls = {},
      marksman = {},
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
        local file_path = vim.api.nvim_buf_get_name(args.buf)

        -- Search up directory tree for Xcode project
        local function find_xcode_root(path)
          local current = vim.fn.fnamemodify(path, ':h')
          while current ~= '/' do
            local xcodeproj = vim.fn.glob(current .. '/*.xcodeproj', false, true)
            local xcworkspace = vim.fn.glob(current .. '/*.xcworkspace', false, true)
            if #xcodeproj > 0 or #xcworkspace > 0 then
              return current
            end
            current = vim.fn.fnamemodify(current, ':h')
          end
          return nil
        end

        local xcode_root = find_xcode_root(file_path)
        local is_xcode_project = xcode_root ~= nil

        -- Find root directory - prefer Xcode project root, then SPM, then fallback
        local root_dir = xcode_root or vim.fs.root(args.buf, { 'Package.swift', 'buildServer.json' }) or vim.fn.getcwd()

        -- Use Xcode's sourcekit-lsp for Xcode projects on macOS (handles iOS SDKs),
        -- fall back to plain sourcekit-lsp for SPM projects and Linux
        local cmd = { 'sourcekit-lsp' }
        if vim.fn.has 'mac' == 1 and is_xcode_project and vim.fn.executable 'xcrun' == 1 then
          cmd = { 'xcrun', 'sourcekit-lsp' }
        end

        vim.lsp.start {
          name = 'sourcekit-lsp',
          cmd = cmd,
          root_dir = root_dir,
          capabilities = capabilities,
        }
      end,
    })
  end,
}
