-- Obsidian notes, only activated for markdown files inside the vault.
-- The vault lives in a different place on each machine, so the first path that
-- exists wins. Uses LazyVim's snacks picker instead of telescope.
-- Vault conventions (folders, `type` property, templates) are written down in
-- the vault itself: "Vault — правила.md".
local home = vim.fn.expand("~")
local vault = home .. "/Documents/Obsidian/Zettel"
for _, path in ipairs({ home .. "/Obsidian/Zettel", home .. "/Documents/Obsidian/Zettel" }) do
  if vim.fn.isdirectory(path) == 1 then
    vault = path
    break
  end
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    "BufReadPre " .. vault .. "/*.md",
    "BufNewFile " .. vault .. "/*.md",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    workspaces = { { name = "Zettel", path = vault } },
    completion = { min_chars = 2 },
    picker = { name = "snacks.picker" },
    legacy_commands = false,
    -- No extra concealing/checkbox glyphs: avoids the conceallevel warning on every open.
    ui = { enable = false },

    -- The plugin must not rewrite frontmatter on save: by default it inserts
    -- id/aliases/tags into every note it touches.
    frontmatter = { enabled = false },

    -- File name is the title as typed, not a random zettel id.
    note_id_func = function(title)
      if type(title) == "string" and vim.trim(title) ~= "" then
        return (vim.trim(title):gsub("[/\\:]", "-"))
      end
      return os.date("%Y-%m-%d %H%M")
    end,

    -- New notes land in Inbox and are sorted from there.
    notes_subdir = "Inbox",
    new_notes_location = "notes_subdir",
    note = { template = "~ нотатка.md" },

    templates = { folder = "Templates" },

    daily_notes = {
      folder = "Daily",
      template = "~ day.md",
      default_tags = {},
      workdays_only = false,
    },
  },
}
