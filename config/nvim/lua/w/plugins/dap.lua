--
-- nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
-- https://github.com/theHamsta/nvim-dap-virtual-text
--

return {
  'mfussenegger/nvim-dap',
  lazy = true,
  version = '*',
  dependencies = {
    { 'rcarriga/nvim-dap-ui', version = '*' },
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    local function opts(desc)
      return {
        desc = 'DAP: ' .. desc,
      }
    end

    -- dap
    local dap = require('dap')

    dap.set_log_level('TRACE')

    vim.keymap.set('n', '<F5>', dap.continue, opts('start / continue menu'))
    vim.keymap.set('n', '<F17>', dap.terminate, opts('terminate, Shift-F5'))
    vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, opts('toggle breakpoint'))
    vim.keymap.set(
      'n',
      '<F21>',
      "<cmd>lua require('dap').toggle_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
      opts('conditional breakpoint, Shift-F9')
    )
    vim.keymap.set(
      'n',
      '<Leader>dp',
      "<cmd>lua require('dap').toggle_breakpoint(nil, nil, vim.fn.input('Log breakpoint message: '))<cr>",
      opts('log point')
    )
    vim.keymap.set(
      'n',
      '<Leader>de',
      "<cmd>lua require('dap').set_exception_breakpoints()<cr>",
      opts('exception breakpoints')
    )
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

    vim.keymap.set('n', '<Leader>du', dapui.toggle, opts('UI toggle'))

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
      require('focus').focus_disable_window()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      require('focus').focus_enable_window()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      require('focus').focus_enable_window()
    end

    -- dap-virtual-text
    require('nvim-dap-virtual-text').setup()

    -- icons in gutter
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapUIWatchesError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapUIWatchesError' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapUIWatchesError' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapUIWatchesError' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapUIPlayPause' })
  end,
}
