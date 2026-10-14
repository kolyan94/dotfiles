-- OPT-IN: `-` is a Vim motion (up a line, first non-blank); this repurposes it for Oil
return {
  "stevearc/oil.nvim",
  keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" } },
}
