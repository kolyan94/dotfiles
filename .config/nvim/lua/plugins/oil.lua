-- File explorer
return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  config = function()
    require('oil').setup {
      default_file_explorer = true,
      columns = { 'icon', 'permissions', 'size', 'mtime' },
      delete_to_trash = true,
      view_options = {
        show_hidden = false,
      },
    }

    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    vim.keymap.set('n', '<leader>-', function()
      require('oil').toggle_float()
    end, { desc = 'Open oil float' })
  end,
}
