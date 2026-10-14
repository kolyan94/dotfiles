-- LazyVim ships bufferline; only the look is adjusted. The old hardcoded
-- solarized highlights are gone so it follows the Omarchy theme.
return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      separator_style = "slant",
      show_buffer_close_icons = false,
      show_close_icon = false,
    },
  },
}
