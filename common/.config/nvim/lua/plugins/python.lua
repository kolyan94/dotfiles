-- Python extras shared by macOS and Omarchy: virtualenv picker and pytest runner.
-- LSP (basedpyright + ruff), formatting and debugging live in each platform's lspconfig/conform/dap.
-- Keys: <leader>cv pick venv, <leader>T* tests (<leader>t is the toggle group on both setups).
local python = function()
  return require("dotfiles.python").python()
end

return {
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    cmd = "VenvSelect",
    keys = { { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python venv", ft = "python" } },
    opts = { options = { notify_user_on_venv_activation = true } },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    keys = {
      { "<leader>Tt", function() require("neotest").run.run() end, desc = "Test: Run Nearest" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run File" },
      { "<leader>TT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test: Run All" },
      { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Test: Run Last" },
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug Nearest" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Test: Summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Output" },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Test: Output Panel" },
      { "<leader>TS", function() require("neotest").run.stop() end, desc = "Test: Stop" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({ runner = "pytest", python = python, dap = { justMyCode = false } }),
        },
      })
    end,
  },
}
