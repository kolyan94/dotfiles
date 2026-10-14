-- Obsidian notes, only activated for markdown files inside the vault below.
-- The vault path is unchanged from the macOS config: edit it if the vault lives
-- somewhere else on this machine. Uses LazyVim's snacks picker instead of telescope.
local vault = vim.fn.expand("~") .. "/Documents/Obsidian/Zettel"

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    "BufReadPre " .. vault .. "/*.md",
    "BufNewFile " .. vault .. "/*.md",
  },
  dependencies = { "nvim-lua/plenary.nvim", "saghen/blink.cmp" },
  opts = {
    workspaces = { { name = "Zettel", path = "~/Documents/Obsidian/Zettel" } },
    completion = { blink = true, nvim_cmp = false, min_chars = 2 },
    picker = { name = "snacks.pick" },
    legacy_commands = false,
  },
}
