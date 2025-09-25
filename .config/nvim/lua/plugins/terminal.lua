-- Terminal and workflow enhancements
return {
  -- Floating terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    lazy = false, -- Load immediately
    config = function()
      require('toggleterm').setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
      })

      -- Terminal keymaps
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      -- Specialized terminals
      local Terminal = require('toggleterm.terminal').Terminal

      -- Lazygit terminal
      local lazygit = Terminal:new({
        cmd = 'lazygit',
        dir = 'git_dir',
        direction = 'float',
        float_opts = {
          border = 'double',
        },
        on_open = function(term)
          vim.cmd('startinsert!')
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
        end,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      -- Python REPL
      local python = Terminal:new({
        cmd = 'python3',
        direction = 'vertical',
        size = vim.o.columns * 0.4,
      })

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      -- Custom keymaps
      vim.keymap.set('n', '<leader>gg', function() lazygit:toggle() end, { desc = 'Toggle Lazygit' })
      vim.keymap.set('n', '<leader>tp', function() python:toggle() end, { desc = 'Toggle Python REPL' })
    end,
  },

  -- Session management
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {
      options = vim.opt.sessionoptions:get(),
    },
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
      { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
      { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- Startup screen
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')

      -- Header
      dashboard.section.header.val = {
        '                                                     ',
        '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        '                                                     ',
      }

      -- Menu
      dashboard.section.buttons.val = {
        dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
        dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('p', '  Find project', ':Telescope projects <CR>'),
        dashboard.button('r', '  Recently used files', ':Telescope oldfiles <CR>'),
        dashboard.button('t', '  Find text', ':Telescope live_grep <CR>'),
        dashboard.button('c', '  Configuration', ':e ~/.config/nvim/init.lua <CR>'),
        dashboard.button('q', '  Quit Neovim', ':qa<CR>'),
      }

      -- Footer
      local function get_footer()
        if vim.fn.executable('fortune') == 1 then
          local handle = io.popen('fortune')
          local fortune = handle:read('*a')
          handle:close()
          return fortune
        else
          return 'Welcome to Neovim! 🚀'
        end
      end
      dashboard.section.footer.val = get_footer()

      dashboard.section.footer.opts.hl = 'Type'
      dashboard.section.header.opts.hl = 'Include'
      dashboard.section.buttons.opts.hl = 'Keyword'

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
    end,
  },

  -- Better quickfix and location list
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            ret = false
          end
          return ret
        end
      },
    },
  },

  -- Better buffer management
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    lazy = false, -- Load immediately
    config = function()
      require('bufferline').setup({
        options = {
          mode = 'buffers',
          separator_style = 'slant',
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true,
        },
        highlights = {
          separator = {
            fg = '#073642',
            bg = '#002b36',
          },
          separator_selected = {
            fg = '#073642',
          },
          background = {
            fg = '#657b83',
            bg = '#002b36'
          },
          buffer_selected = {
            fg = '#fdf6e3',
            bold = true,
          },
          fill = {
            bg = '#073642'
          }
        },
      })

      -- Buffer navigation keymaps
      vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
      vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
      vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
      vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
    end,
  },
}