-- Oil file explorer. Omarchy's LazyVim enables the neo-tree extra, which already
-- handles `nvim .` (Omarchy's `n` alias), so oil must NOT hijack directory
-- buffers: default_file_explorer is off and oil is opened explicitly (:Oil or
-- <leader>fo). `-` (a Vim motion) is only mapped in the opt-in overrides.
return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = {
    { "<leader>fo", function() require("oil").toggle_float() end, desc = "Oil (float)" },
  },
  opts = {
    default_file_explorer = false,
    columns = { "icon", "permissions", "size", "mtime" },
    delete_to_trash = true,
    view_options = { show_hidden = false },
  },
}
