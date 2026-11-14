-- Better code folding (treesitter, then indent)
return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  event = "VeryLazy",
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
  },
  init = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = {
    provider_selector = function() return { "treesitter", "indent" } end,
  },
}
