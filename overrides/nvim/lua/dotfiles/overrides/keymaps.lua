-- OPT-IN keymaps that redefine existing Neovim / LazyVim keys.
local map = vim.keymap.set

-- Arrow keys off (pairs with hardtime.nvim)
for _, mode in ipairs({ "n", "i", "v", "x", "s", "o", "c" }) do
  for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
    map(mode, key, "<Nop>", { desc = "Disabled" })
  end
end

map("n", "J", "mzJ`z", { desc = "Join lines, keep cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous match (centered)" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("i", "jk", "<Esc>", { desc = "Escape" })
