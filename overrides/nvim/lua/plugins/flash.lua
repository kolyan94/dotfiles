-- LazyVim ships flash with the same s / S / r / R keys; only add char-mode labels
return {
  "folke/flash.nvim",
  opts = { modes = { char = { jump_labels = true } } },
}
