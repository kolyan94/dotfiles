-- Debug Adapter Protocol (DAP) configuration
return {
  -- Core DAP functionality
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- Mason DAP setup
      require('mason-nvim-dap').setup({
        automatic_setup = true,
        handlers = {},
        ensure_installed = {
          'python', -- Python debugging
          'codelldb', -- C/C++/Rust debugging
        },
      })

      -- Virtual text for debugging
      require('nvim-dap-virtual-text').setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
      })

      -- DAP UI setup
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
            terminate = ""
          }
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = "single",
          mappings = {
            close = { "q", "<Esc>" }
          }
        },
        force_buffers = true,
        icons = {
          collapsed = "",
          current_frame = "",
          expanded = ""
        },
        layouts = { {
            elements = { {
                id = "scopes",
                size = 0.25
              }, {
                id = "breakpoints",
                size = 0.25
              }, {
                id = "stacks",
                size = 0.25
              }, {
                id = "watches",
                size = 0.25
              } },
            position = "left",
            size = 40
          }, {
            elements = { {
                id = "repl",
                size = 0.5
              }, {
                id = "console",
                size = 0.5
              } },
            position = "bottom",
            size = 10
          } },
        mappings = {
          edit = "e",
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t"
        },
        render = {
          indent = 1,
          max_value_lines = 100
        }
      })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Python debugging configuration
      dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or '127.0.0.1'
          cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
              source_filetype = 'python',
            },
          })
        else
          cb({
            type = 'executable',
            command = 'python',
            args = { '-m', 'debugpy.adapter' },
            options = {
              source_filetype = 'python',
            },
          })
        end
      end

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end,
        },
      }

      -- C/C++ debugging with CodeLLDB
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'codelldb',
          args = { '--port', '${port}' },
        }
      }

      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- Swift debugging (basic LLDB setup)
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode',
        name = 'lldb'
      }

      dap.configurations.swift = {
        {
          name = 'Launch Swift',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }

      -- Keymaps for debugging
      vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', function() dap.step_into() end, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', function() dap.step_over() end, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', function() dap.step_out() end, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = 'Debug: Set Conditional Breakpoint' })
      vim.keymap.set('n', '<F7>', function() dapui.toggle() end, { desc = 'Debug: Toggle UI' })
    end,
  },
}