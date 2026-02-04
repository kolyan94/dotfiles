-- Status line
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'tokyonight',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          { 'filename', file_status = true, path = 1 },
        },
        lualine_x = {
          function()
            local clients = vim.lsp.get_clients { bufnr = 0 }
            if next(clients) == nil then
              return 'No LSP'
            end
            return 'LSP: ' .. clients[1].name
          end,
          'encoding',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    }
  end,
}
