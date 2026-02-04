-- Project-wide find and replace
return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>sr', function() require('spectre').open() end, desc = '[S]earch and [R]eplace' },
    { '<leader>sw', function() require('spectre').open_visual { select_word = true } end, desc = '[S]earch current [W]ord' },
    { '<leader>sf', function() require('spectre').open_file_search { select_word = true } end, desc = '[S]earch in current [F]ile' },
  },
}
