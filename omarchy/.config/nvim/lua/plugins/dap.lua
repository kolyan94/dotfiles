-- Debugging (nvim-dap + dap-ui). Kept as its own setup rather than LazyVim's
-- dap.core extra so the F-key workflow and the python / codelldb / swift adapters
-- stay as they were. Loads on first use of a debug key.
--
-- Dropped: xcodebuild.nvim (macOS only). Breakpoint keys moved from <leader>b/B
-- (LazyVim's buffer group) to <leader>db / <leader>dB (LazyVim's debug group).
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
    { "<F1>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
    { "<F2>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
    { "<F3>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
    { "<F7>", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    {
      "<leader>dB",
      function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
      desc = "Debug: Conditional Breakpoint",
    },
  },
  config = function()
    local dap = require("dap")
    local py = require("dotfiles.python")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      automatic_setup = true,
      handlers = {},
      ensure_installed = { "python", "codelldb" },
    })

    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
    })

    dapui.setup({
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = "",
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = { border = "single", mappings = { close = { "q", "<Esc>" } } },
      force_buffers = true,
      icons = { collapsed = "", current_frame = "", expanded = "" },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
          position = "bottom",
          size = 10,
        },
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      render = { indent = 1, max_value_lines = 100 },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    -- Python
    dap.adapters.python = function(cb, config)
      if config.request == "attach" then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
          type = "server",
          port = assert(port, "`connect.port` is required for a python `attach` configuration"),
          host = host,
          options = { source_filetype = "python" },
        })
      else
        -- debugpy from mason, so projects need not install it; the code runs in the venv's python
        cb({
          type = "executable",
          command = py.debugpy_python(),
          args = { "-m", "debugpy.adapter" },
          options = { source_filetype = "python" },
        })
      end
    end

    local venv = function() return py.python() end
    dap.configurations.python = {
      { type = "python", request = "launch", name = "Launch file", program = "${file}", pythonPath = venv },
      {
        type = "python",
        request = "launch",
        name = "Launch file with arguments",
        program = "${file}",
        args = function() return vim.split(vim.fn.input("Arguments: "), " +", { trimempty = true }) end,
        pythonPath = venv,
      },
      {
        type = "python",
        request = "launch",
        name = "Launch module",
        module = function() return vim.fn.input("Module (e.g. app.main): ") end,
        cwd = "${workspaceFolder}",
        pythonPath = venv,
      },
      {
        type = "python",
        request = "attach",
        name = "Attach (localhost:5678, python -m debugpy --listen 5678)",
        connect = { host = "127.0.0.1", port = 5678 },
      },
    }

    -- C / C++ (CodeLLDB)
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = { command = "codelldb", args = { "--port", "${port}" } },
    }
    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp

    -- Swift (Linux toolchain: lldb-dap, formerly lldb-vscode)
    dap.adapters.lldb = {
      type = "executable",
      command = vim.fn.executable("lldb-dap") == 1 and "lldb-dap" or "/usr/bin/lldb-vscode",
      name = "lldb",
    }
    dap.configurations.swift = {
      {
        name = "Launch Swift",
        type = "lldb",
        request = "launch",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
    }
  end,
}
