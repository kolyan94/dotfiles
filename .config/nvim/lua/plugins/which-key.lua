-- Which-key for keymap hints
return {
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
      { '<leader>h', group = '[H]unk' },
      { '<leader>q', group = '[Q]uit/Session' },
      { '<leader>x', group = 'Swap' },
    },
  },
}
