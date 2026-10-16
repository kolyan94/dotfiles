-- LazyVim ships treesitter (main branch) with most parsers and mini.ai
-- treesitter textobjects (af/if/ac/ic). Only the extra parsers are added.
return {
  "nvim-treesitter/nvim-treesitter",
  opts = { ensure_installed = { "cpp", "php", "rust", "swift" } },
}
