-- Xcode build, test and debug (macOS). Same <leader>i keys as xtool on Linux (common/.../xtool.lua):
-- <leader>ir build + run, <leader>ib build, <leader>id device. Breakpoints: <leader>db / <leader>dB (dap.lua).
local function cmd(c)
  return "<cmd>" .. c .. "<cr>"
end
local function dap(fn)
  return function()
    require("xcodebuild.integrations.dap")[fn]()
  end
end

return {
  {
    "wojciech-kulik/xcodebuild.nvim",
    cond = vim.fn.has("mac") == 1,
    ft = { "swift", "objc", "objcpp" },
    cmd = { "XcodebuildSetup", "XcodebuildPicker", "XcodebuildBuild", "XcodebuildBuildRun", "XcodebuildTest", "XcodebuildSelectDevice", "XcodebuildSelectScheme" },
    dependencies = { "nvim-telescope/telescope.nvim", "MunifTanjim/nui.nvim", "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>ip", cmd("XcodebuildPicker"), desc = "Xcode actions" },
      { "<leader>ir", cmd("XcodebuildBuildRun"), desc = "Build + run" },
      { "<leader>ib", cmd("XcodebuildBuild"), desc = "Build" },
      { "<leader>iB", cmd("XcodebuildBuildForTesting"), desc = "Build for testing" },
      { "<leader>id", cmd("XcodebuildSelectDevice"), desc = "Select device" },
      { "<leader>is", cmd("XcodebuildSelectScheme"), desc = "Select scheme" },
      { "<leader>it", cmd("XcodebuildTest"), desc = "Run tests" },
      { "<leader>it", cmd("XcodebuildTestSelected"), mode = "v", desc = "Run selected tests" },
      { "<leader>iT", cmd("XcodebuildTestClass"), desc = "Test class" },
      { "<leader>i.", cmd("XcodebuildTestRepeat"), desc = "Repeat last test" },
      { "<leader>il", cmd("XcodebuildToggleLogs"), desc = "Toggle logs" },
      { "<leader>ic", cmd("XcodebuildToggleCodeCoverage"), desc = "Toggle coverage" },
      { "<leader>iC", cmd("XcodebuildShowCodeCoverageReport"), desc = "Coverage report" },
      { "<leader>ie", cmd("XcodebuildTestExplorerToggle"), desc = "Test explorer" },
      { "<leader>if", cmd("XcodebuildProjectManager"), desc = "Project manager" },
      { "<leader>ix", cmd("XcodebuildQuickfixLine"), desc = "Quickfix line" },
      { "<leader>ia", cmd("XcodebuildCodeActions"), desc = "Code actions" },
      { "<leader>iD", dap("build_and_debug"), desc = "Build + debug" },
      { "<leader>iR", dap("debug_without_build"), desc = "Debug without build" },
      { "<leader>iY", dap("debug_tests"), desc = "Debug tests" },
      { "<leader>iX", dap("terminate_session"), desc = "Stop debugger" },
    },
    config = function()
      require("xcodebuild").setup({
        integrations = {
          oil_nvim = { enabled = true },
          xcode_build_server = { enabled = true },
          pymobiledevice = { enabled = true },
        },
      })
      require("xcodebuild.integrations.dap").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>i", group = "iOS (Xcode)", icon = "" } } },
  },
}
