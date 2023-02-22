--
-- nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
-- https://github.com/theHamsta/nvim-dap-virtual-text
--

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- dap
local has_dap, dap = pcall(require, 'dap')

if has_dap then
  dap.set_log_level('TRACE')

  keymap('n', '<F5>', dap.continue, opts)
  keymap('n', '<F17>', dap.terminate, opts) -- Shift-F5
  keymap('n', '<F9>', dap.toggle_breakpoint, opts)
  keymap('n', '<F21>', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", opts) -- Shift-F9
  keymap(
    'n',
    '<Leader>lp',
    "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
    opts
  )
  keymap('n', '<F10>', dap.step_over, opts)
  keymap('n', '<F11>', dap.step_into, opts)
  keymap('n', '<F22>', dap.step_out, opts) -- Shift-F11
  keymap('n', '<Leader>dr', dap.repl.open, opts)
  keymap('n', '<Leader>dl', dap.run_last, opts)
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

  keymap('n', '<Leader>du', dapui.toggle, opts)

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
