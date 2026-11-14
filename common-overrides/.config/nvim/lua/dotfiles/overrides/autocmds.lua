-- Personal autocmds. LazyVim already highlights yanked text.

-- clang-format is run by hand (<leader>cf) for C/C++, never on save
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("dotfiles_no_autoformat", { clear = true }),
  pattern = { "c", "cpp" },
  callback = function()
    vim.b.autoformat = false
  end,
})
