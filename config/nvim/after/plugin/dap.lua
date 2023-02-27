--
-- nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
-- https://github.com/theHamsta/nvim-dap-virtual-text
--

local function opts(desc)
  return {
    desc = 'DAP: ' .. desc,
  }
end

-- dap
local has_dap, dap = pcall(require, 'dap')

if has_dap then
  dap.set_log_level('TRACE')

  vim.keymap.set('n', '<F5>', dap.continue, opts('start / continue menu'))
  vim.keymap.set('n', '<F17>', dap.terminate, opts('terminate, Shift-F5'))
  vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, opts('toggle breakpoint'))
  vim.keymap.set(
    'n',
    '<F21>',
    "<cmd>lua require('dap').toggle_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
    opts('conditional breakpoint, Shift-F9')
  ) -- Shift-F9
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
end

-- dapui
local has_dapui, dapui = pcall(require, 'dapui')

if has_dapui then
  dapui.setup({
    mappings = {
      expand = { 'o', '<2-LeftMouse>' },
      open = 'O',
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
  end
end

-- dap-virtual-text
local has_dap_virtual_text, dap_virtual_text = pcall(require, 'nvim-dap-virtual-text')

if has_dap_virtual_text then
  dap_virtual_text.setup()
end

-- icons in gutter
if has_dapui then
  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapUIWatchesError' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapUIWatchesError' })
  vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapUIWatchesError' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapUIWatchesError' })
  vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapUIPlayPause' })
end
