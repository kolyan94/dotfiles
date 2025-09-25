-- Core editing plugins
return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Auto-pairs for brackets, quotes, etc.
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  -- Lightning-fast navigation
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = {
        search = { enabled = false }, -- Don't override default search
        char = { jump_labels = true }, -- Show labels on f/F/t/T
      },
    },
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'o', 'x' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
    },
  },

  -- Multiple cursors
  {
    'mg979/vim-visual-multi',
    event = 'VeryLazy',
    init = function()
      vim.g.VM_maps = {
        ['Find Under'] = '<C-n>',
        ['Find Subword Under'] = '<C-n>',
        ['Select All'] = '<C-S-n>',
        ['Skip Region'] = '<C-x>',
        ['Remove Region'] = '<C-p>',
      }
    end,
  },

  -- Enhanced text objects and surround
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup {
        n_lines = 500,
        custom_textobjects = {
          o = require('mini.ai').gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
        },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup()

      -- Better code commenting
      require('mini.comment').setup()

      -- Move selections with Alt+j/k
      require('mini.move').setup({
        mappings = {
          -- Move visual selection in Visual mode
          left = '<M-h>',
          right = '<M-l>',
          down = '<M-j>',
          up = '<M-k>',

          -- Move current line in Normal mode
          line_left = '<M-h>',
          line_right = '<M-l>',
          line_down = '<M-j>',
          line_up = '<M-k>',
        },
      })
    end,
  },

  -- Enhanced treesitter text objects
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    config = function()
      -- Ensure treesitter is loaded first
      require('nvim-treesitter.configs').setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['as'] = '@scope.outer',
              ['is'] = '@scope.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
        },
      })
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = { char = '│' },
      scope = { show_start = false, show_end = false },
    },
  },

  -- Todo comments highlighting
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },

  -- Project-wide find and replace
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>sr', function() require('spectre').open() end, desc = '[S]earch and [R]eplace' },
      { '<leader>sw', function() require('spectre').open_visual({ select_word = true }) end, desc = '[S]earch current [W]ord' },
      { '<leader>sf', function() require('spectre').open_file_search({ select_word = true }) end, desc = '[S]earch in current [F]ile' },
    },
  },

  -- Better code folding
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })
    end,
  },
}