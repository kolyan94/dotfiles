-- Claude Code inside Neovim: the same IDE protocol as the VS Code / JetBrains extensions
-- (Claude sees the open file and selection, proposes diffs you accept or reject in nvim)
return {
  "coder/claudecode.nvim",
  cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeAdd", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny" },
  opts = {},
  keys = {
    { "<leader>a", nil, desc = "AI / Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude session" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
