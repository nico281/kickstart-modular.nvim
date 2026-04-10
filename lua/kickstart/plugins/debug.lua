-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Ruby/Rails debug adapter
    'suketa/nvim-dap-ruby',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
    {
      '<leader>do',
      function()
        require('dapui').open()
      end,
      desc = 'Debug: Open UI',
    },
    {
      '<leader>dc',
      function()
        require('dapui').close()
      end,
      desc = 'Debug: Close UI',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
        require('dapui').close()
      end,
      desc = 'Debug: Terminate and Close UI',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        'js-debug-adapter',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    -- Ruby/Rails DAP setup. nvim-dap-ruby registers the adapter as "ruby".
    require('dap-ruby').setup()
    dap.adapters.rdbg = dap.adapters.ruby

    -- Override Ruby configs with longer waiting time for Rails boot.
    local base = { type = 'ruby', request = 'attach', options = { source_filetype = 'ruby' }, error_on_failure = true, localfs = true }
    dap.configurations.ruby = {
      vim.tbl_extend('force', base, { name = 'run rails', command = 'rdbg', args = { '-n', '-c', 'bin/rails', 's' }, random_port = true, waiting = 5000 }),
      vim.tbl_extend('force', base, { name = 'debug current file', command = 'rdbg', current_file = true, random_port = true, waiting = 1000 }),
      vim.tbl_extend('force', base, { name = 'run rspec current file', command = 'bundle', args = { 'exec', 'rspec' }, current_file = true, random_port = true, waiting = 1000 }),
      vim.tbl_extend('force', base, { name = 'run rspec current_line', command = 'bundle', args = { 'exec', 'rspec' }, current_line = true, random_port = true, waiting = 1000 }),
      vim.tbl_extend('force', base, { name = 'bin/dev', command = 'bin/dev', random_port = true, waiting = 5000 }),
      vim.tbl_extend('force', base, { name = 'attach existing (port 38698)', port = 38698, waiting = 0 }),
    }

    local function normalize_ruby_configs()
      for _, config in ipairs(dap.configurations.ruby or {}) do
        if config.type == 'rdbg' then
          config.options = config.options or { source_filetype = 'ruby' }
          config.localfs = config.localfs == nil and true or config.localfs

          if config.request == 'attach' then
            config.port = config.port or 38698
            config.host = config.host or '127.0.0.1'
            config.waiting = config.waiting or 0
          elseif config.request == 'launch' and config.script == '${file}' then
            config.type = 'ruby'
            config.request = 'attach'
            config.command = 'rdbg'
            config.current_file = true
            config.random_port = true
            config.waiting = config.waiting or 1000
          end
        end
      end
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- JS/TS config
    local js_debug_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js'
    if vim.fn.filereadable(js_debug_path) == 1 then
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { js_debug_path, '${port}' },
        },
      }
      require('dap.ext.vscode').load_launchjs(nil, {
        ['pwa-node'] = { 'javascript', 'typescript' },
        rdbg = { 'ruby' },
      })
      normalize_ruby_configs()
    end
  end,
}
