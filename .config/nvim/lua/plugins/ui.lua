-- UI and interface plugins
return {
  -- Color scheme
  {
    'folke/tokyonight.nvim',
    lazy = false, -- Don't lazy load the theme
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'tokyonight',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {
            {
              'filename',
              file_status = true,
              path = 1,
            }
          },
          lualine_x = {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if next(clients) == nil then
                return 'No LSP'
              end
              return 'LSP: ' .. clients[1].name
            end,
            'encoding',
            'filetype'
          },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },

  -- File explorer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false, -- Load immediately
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        columns = { 'icon', 'permissions', 'size', 'mtime' },
        delete_to_trash = true,
        view_options = {
          show_hidden = false,
        },
      })

      -- Keymaps
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<leader>-', function() require('oil').toggle_float() end, { desc = 'Open oil float' })
    end,
  },

  -- Enhanced UI with floating windows
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
        messages = {
          enabled = true,
          view = 'notify',
          view_error = 'notify',
          view_warn = 'notify',
          view_history = 'messages',
          view_search = 'virtualtext',
        },
        cmdline = {
          enabled = true,
          view = 'cmdline_popup',
          format = {
            cmdline = { pattern = '^:', icon = '', lang = 'vim' },
            search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
            search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
            filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
            lua = { pattern = '^:%s*lua%s+', icon = '', lang = 'lua' },
            help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
          },
        },
        popupmenu = {
          enabled = true,
          backend = 'nui',
        },
      })
    end,
  },

  -- Notification manager
  {
    'rcarriga/nvim-notify',
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  -- Which-key for keymap hints
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          Tab = '<Tab> ',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>g', group = '[G]it' },
        { '<leader>t', group = '[T]oggle' },
      },
    },
  },
}