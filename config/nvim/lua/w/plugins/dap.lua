--
-- nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
-- https://github.com/theHamsta/nvim-dap-virtual-text
--

-- icons in gutter
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapUIWatchesError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapUIWatchesError' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapUIWatchesError' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapUIWatchesError' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapUIPlayPause' })

return {
  'mfussenegger/nvim-dap',
  version = '*',
  dependencies = {
    { 'rcarriga/nvim-dap-ui', version = '*', dependencies = { 'nvim-neotest/nvim-nio' } },
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      mode = 'n',
      desc = 'DAP: start / continue menu',
    },
    {
      '<F9>',
      function()
        require('dap').toggle_breakpoint()
      end,
      mode = 'n',
      desc = 'DAP: toggle breakpoint',
    },
    {
      '<F21>',
      function()
        require('dap').toggle_breakpoint(vim.fn.input('Breakpoint condition: '))
      end,
      mode = 'n',
      desc = 'DAP: conditional breakpoint, Shift-F9',
    },
    {
      '<Leader>do',
      function()
        require('dap').toggle_breakpoint(nil, nil, vim.fn.input('Log breakpoint message: '))
      end,
      mode = 'n',
      desc = 'DAP: log breakpoint',
    },
    {
      '<Leader>de',
      function()
        require('dap').set_exception_breakpoints()
      end,
      mode = 'n',
      desc = 'DAP: exception breakpoint',
    },
    {
      '<Leader>du',
      function()
        require('dapui').toggle()
      end,
      mode = 'n',
      desc = 'DAP: UI toggle',
    },
  },
  config = function()
    local function opts(desc)
      return {
        desc = 'DAP: ' .. desc,
      }
    end

    -- dap
    local dap = require('dap')

    vim.keymap.set('n', '<F17>', dap.terminate, opts('terminate, Shift-F5'))
    vim.keymap.set('n', '<F10>', dap.step_over, opts('step over'))
    vim.keymap.set('n', '<F11>', dap.step_into, opts('step into'))
    vim.keymap.set('n', '<F22>', dap.step_out, opts('step out, Shift-F11'))
    vim.keymap.set('n', '<Leader>dr', dap.repl.open, opts('REPL open'))
    vim.keymap.set('n', '<Leader>dl', dap.run_last, opts('run last'))
    vim.keymap.set('n', '<Leader>dh', "<cmd>lua require('dap.ui.widgets').hover()<cr>", opts('hover popup'))

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
