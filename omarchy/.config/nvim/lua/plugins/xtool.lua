-- iOS development on Linux with xtool (https://xtool.sh), the stand-in for xcodebuild.nvim
-- (macOS only). xtool builds SwiftPM apps with an iOS SDK and installs them on a USB-connected
-- iPhone; there is no simulator. sourcekit-lsp (lspconfig.lua) picks up the project's
-- .bsp/xtool.json on its own, so this only adds commands and keys.

-- swiftly's toolchain, for an nvim started outside zsh (app launcher) where .zshenv never ran
local swiftly_bin = vim.fn.expand("~/.local/share/swiftly/bin")
if vim.fn.isdirectory(swiftly_bin) == 1 and not vim.env.PATH:find(swiftly_bin, 1, true) then
  vim.env.PATH = swiftly_bin .. ":" .. vim.env.PATH
end

-- Directory holding xtool.yml above the current buffer, else the cwd
local function root()
  local found = vim.fs.find("xtool.yml", { upward = true, path = vim.fn.expand("%:p:h") })[1]
  return found and vim.fs.dirname(found) or vim.fn.getcwd()
end

-- Run an xtool subcommand in a Snacks terminal that stays open to show the result
local function xtool(args)
  return function()
    Snacks.terminal(vim.list_extend({ "xtool" }, args), { cwd = root(), auto_close = false })
  end
end

vim.api.nvim_create_user_command("XtoolNew", function(cmd)
  Snacks.terminal({ "xtool", "new", cmd.args }, { cwd = vim.fn.getcwd(), auto_close = false })
end, { nargs = 1, desc = "xtool: new iOS project in the cwd" })

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ir", xtool({ "dev" }), desc = "Build + run on iPhone" },
      { "<leader>ib", xtool({ "dev", "build" }), desc = "Build" },
      { "<leader>id", xtool({ "devices" }), desc = "List devices" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>i", group = "iOS (xtool)", icon = "" } } },
  },
}
