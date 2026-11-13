-- Autocommands configuration
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- Compose files get their own filetype so the compose language server attaches (yamlls still does too)
vim.filetype.add {
  pattern = {
    ['.*/?compose%.ya?ml'] = 'yaml.docker-compose',
    ['.*/?docker%-compose[%w.-]*%.ya?ml'] = 'yaml.docker-compose',
  },
}
