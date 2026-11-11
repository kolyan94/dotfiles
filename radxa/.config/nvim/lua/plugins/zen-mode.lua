-- Radxa deck only: distraction-free writing (`write` command, <leader>z).
return {
  'folke/zen-mode.nvim',
  cmd = 'ZenMode',
  keys = { { '<leader>z', '<cmd>ZenMode<CR>', desc = 'Zen mode' } },
  opts = {
    window = { width = 90, options = { number = false, relativenumber = false, signcolumn = 'no', cursorline = false } },
    plugins = { tmux = { enabled = true }, kitty = { enabled = false } },
  },
}
