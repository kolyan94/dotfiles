-- Keymaps configuration
-- See `:help vim.keymap.set()`

-- Disable arrow keys to enforce vim navigation
local modes = { 'n', 'i', 'v', 'x', 's', 'o', 'c' }
for _, mode in ipairs(modes) do
  vim.keymap.set(mode, '<Up>', '<Nop>', { desc = 'Disabled' })
  vim.keymap.set(mode, '<Down>', '<Nop>', { desc = 'Disabled' })
  vim.keymap.set(mode, '<Left>', '<Nop>', { desc = 'Disabled' })
  vim.keymap.set(mode, '<Right>', '<Nop>', { desc = 'Disabled' })
end

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode with a shortcut
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Better text editing
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page up and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result centered' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result centered' })

-- Better indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Move text up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Better paste
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without yanking' })

-- Copy to system clipboard
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]], { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank line to system clipboard' })

-- Delete without yanking
vim.keymap.set({'n', 'v'}, '<leader>d', [["_d]], { desc = 'Delete without yanking' })

-- Replace word under cursor
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })

-- Make file executable
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make file executable' })