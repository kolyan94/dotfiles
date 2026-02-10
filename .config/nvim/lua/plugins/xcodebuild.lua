-- Xcode build, test, debug integration (macOS only)
return {
  'wojciech-kulik/xcodebuild.nvim',
  cond = vim.fn.has('mac') == 1,
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'MunifTanjim/nui.nvim',
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    require('xcodebuild').setup {
      integrations = {
        oil_nvim = { enabled = true },
        xcode_build_server = { enabled = true },
        pymobiledevice = { enabled = true },
      },
    }

    -- DAP integration
    local xcodebuild_dap = require('xcodebuild.integrations.dap')
    xcodebuild_dap.setup()

    -- Debug keymaps
    vim.keymap.set('n', '<leader>dd', xcodebuild_dap.build_and_debug, { desc = 'Xcode: Build & Debug' })
    vim.keymap.set('n', '<leader>dr', xcodebuild_dap.debug_without_build, { desc = 'Xcode: Debug Without Build' })
    vim.keymap.set('n', '<leader>dt', xcodebuild_dap.debug_tests, { desc = 'Xcode: Debug Tests' })
    vim.keymap.set('n', '<leader>dT', xcodebuild_dap.debug_class_tests, { desc = 'Xcode: Debug Class Tests' })
    vim.keymap.set('n', '<leader>dx', xcodebuild_dap.terminate_session, { desc = 'Xcode: Terminate Debugger' })
    vim.keymap.set('n', '<leader>b', xcodebuild_dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', xcodebuild_dap.toggle_message_breakpoint, { desc = 'Debug: Toggle Message Breakpoint' })

    -- Keymaps under <leader>x
    vim.keymap.set('n', '<leader>X', '<cmd>XcodebuildPicker<cr>', { desc = 'Xcodebuild Actions' })
    vim.keymap.set('n', '<leader>xf', '<cmd>XcodebuildProjectManager<cr>', { desc = 'Xcode: Project Manager' })
    vim.keymap.set('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', { desc = 'Xcode: Build' })
    vim.keymap.set('n', '<leader>xB', '<cmd>XcodebuildBuildForTesting<cr>', { desc = 'Xcode: Build For Testing' })
    vim.keymap.set('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', { desc = 'Xcode: Build & Run' })
    vim.keymap.set('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', { desc = 'Xcode: Run Tests' })
    vim.keymap.set('v', '<leader>xt', '<cmd>XcodebuildTestSelected<cr>', { desc = 'Xcode: Run Selected Tests' })
    vim.keymap.set('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', { desc = 'Xcode: Test Class' })
    vim.keymap.set('n', '<leader>x.', '<cmd>XcodebuildTestRepeat<cr>', { desc = 'Xcode: Repeat Last Test' })
    vim.keymap.set('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', { desc = 'Xcode: Toggle Logs' })
    vim.keymap.set('n', '<leader>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', { desc = 'Xcode: Toggle Coverage' })
    vim.keymap.set('n', '<leader>xC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', { desc = 'Xcode: Coverage Report' })
    vim.keymap.set('n', '<leader>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', { desc = 'Xcode: Test Explorer' })
    vim.keymap.set('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', { desc = 'Xcode: Select Device' })
    vim.keymap.set('n', '<leader>xq', '<cmd>Telescope quickfix<cr>', { desc = 'Xcode: QuickFix List' })
    vim.keymap.set('n', '<leader>xx', '<cmd>XcodebuildQuickfixLine<cr>', { desc = 'Xcode: Quickfix Line' })
    vim.keymap.set('n', '<leader>xa', '<cmd>XcodebuildCodeActions<cr>', { desc = 'Xcode: Code Actions' })
  end,
}
