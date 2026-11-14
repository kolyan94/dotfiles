-- LazyVim ships which-key; add labels for the personal <leader> prefixes
return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>h", group = "hunk" },
      { "<leader>t", group = "toggle" },
      { "<leader>r", group = "rename/replace" },
    },
  },
}
