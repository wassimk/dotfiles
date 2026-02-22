--
-- nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
-- https://github.com/theHamsta/nvim-dap-virtual-text
--

-- icons in gutter
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapUIBreakpointsPath' })
vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapUIBreakpointsPath' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapUIBreakpointsPath' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapUIBreakpointsPath' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapUIPlayPause' })

return {
  'mfussenegger/nvim-dap',
  version = '*',
  dependencies = {
    { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    {
      '<Leader>dd',
      function()
        require('dap').continue()
      end,
      mode = 'n',
      desc = 'debug / continue',
    },
    {
      '<Leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      mode = 'n',
      desc = 'toggle breakpoint',
    },
    {
      '<Leader>dB',
      function()
        require('dap').toggle_breakpoint(vim.fn.input('Breakpoint condition: '))
      end,
      mode = 'n',
      desc = 'conditional breakpoint',
    },
    {
      '<Leader>do',
      function()
        require('dap').toggle_breakpoint(nil, nil, vim.fn.input('Log breakpoint message: '))
      end,
      mode = 'n',
      desc = 'log breakpoint',
    },
    {
      '<Leader>de',
      function()
        require('dap').set_exception_breakpoints()
      end,
      mode = 'n',
      desc = 'exception breakpoint',
    },
    {
      '<Leader>du',
      function()
        require('dapui').toggle()
      end,
      mode = 'n',
      desc = 'UI toggle',
    },
  },
  config = function()
    local function opts(desc)
      return {
        desc = desc,
      }
    end

    -- dap
    local dap = require('dap')
    local widgets = require('dap.ui.widgets')

    vim.keymap.set('n', '<Leader>dR', dap.repl.open, opts('REPL open'))
    vim.keymap.set('n', '<Leader>dl', dap.run_last, opts('run last'))
    vim.keymap.set('n', '<Leader>dr', dap.run_to_cursor, opts('debug at cursor'))
    vim.keymap.set('n', '<Leader>dh', function()
      widgets.hover()
    end, opts('hover popup'))
    vim.keymap.set('n', '<Leader>dv', function()
      widgets.centered_float(widgets.scopes)
    end, opts('float scopes'))
    vim.keymap.set('n', '<Leader>dt', function()
      widgets.centered_float(widgets.frames)
    end, opts('float frames/stacks'))

    -- dapui
    local dapui = require('dapui')

    dapui.setup({
      element_mappings = {
        scopes = {
          expand = { '<cr>', 'o', '<2-LeftMouse>' },
        },
        breakpoints = {
          open = { 'o' },
          toggle = { 't', '<2-LeftMouse>' },
          expand = {},
        },
        stacks = {
          open = { 'o', '<2-LeftMouse>' },
          expand = {},
        },
      },
      icons = {
        expanded = '▾',
        collapsed = '▸',
        current_frame = '▸',
      },
    })

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- dap-virtual-text
    require('nvim-dap-virtual-text').setup()
  end,
}
