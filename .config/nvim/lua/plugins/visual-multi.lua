-- Multiple cursors
return {
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
}
