-- Omarchy owns the colorscheme (lua/plugins/theme.lua is a symlink it rewrites on
-- `omarchy theme set`). This only merges an option into the tokyonight plugin and
-- is inert when another theme is active.
return {
  "folke/tokyonight.nvim",
  opts = { styles = { comments = { italic = false } } },
}
