-- Project-wide search and replace (ripgrep), replaces nvim-spectre
return {
  'MagicDuck/grug-far.nvim',
  cmd = { 'GrugFar', 'GrugFarWithin' },
  opts = { headerMaxWidth = 80 },
  keys = {
    {
      '<leader>sr',
      function()
        require('grug-far').open()
      end,
      desc = '[S]earch and [R]eplace',
    },
    {
      '<leader>sw',
      function()
        require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } }
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sw',
      function()
        require('grug-far').with_visual_selection()
      end,
      mode = 'x',
      desc = '[S]earch selection',
    },
    {
      '<leader>sR', -- <leader>sf is telescope's find files
      function()
        require('grug-far').open { prefills = { paths = vim.fn.expand '%', search = vim.fn.expand '<cword>' } }
      end,
      desc = '[S]earch and [R]eplace in current file',
    },
  },
}
