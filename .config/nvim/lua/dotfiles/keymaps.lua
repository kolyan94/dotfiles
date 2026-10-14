-- Personal keymaps: ONLY keys that are free in Neovim and LazyVim. Anything that
-- redefines an existing key (J, n/N, Ctrl-d/u, arrows, jk, ...) is in
-- overrides/nvim/lua/dotfiles/overrides/keymaps.lua (opt-in).
--
-- <leader> + s d x f b q g c are LazyVim menu prefixes, so the old bindings that
-- sat directly on them were moved (see SHORTCUTS.md).
local map = vim.keymap.set

-- Registers
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete without yanking" }) -- was <leader>d

-- Was <leader>s (LazyVim search group) and <leader>x (diagnostics group)
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
map("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Pickers: the old Telescope bindings, on LazyVim's snacks picker
map("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Find Files" })
map("n", "<leader>s.", function() Snacks.picker.recent() end, { desc = "Recent Files" })
map("n", "<leader><leader>", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>s/", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
map("n", "<leader>sn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Neovim Config Files" })

-- Git hunks (LazyVim's own are under <leader>gh, with ]h / [h to jump; these keep the old
-- <leader>h muscle memory. ]c / [c stay LazyVim's next/previous class.)
local function gs(fn, ...)
  local args = { ... }
  return function() require("gitsigns")[fn](unpack(args)) end
end
local function gs_range(fn)
  return function() require("gitsigns")[fn]({ vim.fn.line("."), vim.fn.line("v") }) end
end
map("n", "<leader>hs", gs("stage_hunk"), { desc = "Stage Hunk" })
map("n", "<leader>hr", gs("reset_hunk"), { desc = "Reset Hunk" })
map("v", "<leader>hs", gs_range("stage_hunk"), { desc = "Stage Hunk" })
map("v", "<leader>hr", gs_range("reset_hunk"), { desc = "Reset Hunk" })
map("n", "<leader>hS", gs("stage_buffer"), { desc = "Stage Buffer" })
map("n", "<leader>hu", gs("undo_stage_hunk"), { desc = "Undo Stage Hunk" })
map("n", "<leader>hR", gs("reset_buffer"), { desc = "Reset Buffer" })
map("n", "<leader>hp", gs("preview_hunk"), { desc = "Preview Hunk" })
map("n", "<leader>hb", gs("blame_line"), { desc = "Blame Line" })
map("n", "<leader>hd", gs("diffthis"), { desc = "Diff Against Index" })
map("n", "<leader>hD", gs("diffthis", "@"), { desc = "Diff Against Last Commit" })
map("n", "<leader>tb", gs("toggle_current_line_blame"), { desc = "Toggle Line Blame" })
map("n", "<leader>tD", gs("toggle_deleted"), { desc = "Toggle Deleted" })
