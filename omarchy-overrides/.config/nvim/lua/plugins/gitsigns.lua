-- LazyVim ships gitsigns and its <leader>gh* keymaps. Only the gutter glyphs are
-- customised here; the <leader>h* keymaps live in dotfiles/keymaps.lua.
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
}
