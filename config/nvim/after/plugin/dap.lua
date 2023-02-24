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
  vim.keymap.set('n', '<F17>', dap.terminate, opts('terminate, Shift-F5')) -- Shift-F5
  vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, opts('toggle breakpoint'))
  vim.keymap.set(
    'n',
    '<F21>',
    "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
    opts('conditional breakpoint, Shift-F9')
  ) -- Shift-F9
  vim.keymap.set(
    'n',
    '<Leader>lp',
    "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
    opts('log point')
  )
  vim.keymap.set('n', '<F10>', dap.step_over, opts('step over'))
  vim.keymap.set('n', '<F11>', dap.step_into, opts('step into'))
  vim.keymap.set('n', '<F22>', dap.step_out, opts('step out, Shift-F11')) -- Shift-F11
  vim.keymap.set('n', '<Leader>dr', dap.repl.open, opts('REPL open'))
  vim.keymap.set('n', '<Leader>dl', dap.run_last, opts('run last'))
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
    controls = {
      icons = {
        step_back = '',
        run_last = '↻',
      },
    },
  })

  vim.keymap.set('n', '<Leader>du', dapui.toggle, opts('UI toggle'))

  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
  end
end

-- dap-virtual-text
local has_dap_virtual_text, dap_virtual_text = pcall(require, 'nvim-dap-virtual-text')

if has_dap_virtual_text then
  dap_virtual_text.setup()
end

-- icons in gutter
if has_dapui then
  local dap_signs = {
    Breakpoint = 'ﰉ',
    BreakpointCondition = 'ﰊ',
    LogPoint = 'ﯶ',
    Stopped = '',
    BreakpointRejected = 'ﰸ',
  }

  for type, icon in pairs(dap_signs) do
    local hl = 'Dap' .. type

    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end