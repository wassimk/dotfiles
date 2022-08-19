--
-- nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
-- https://github.com/mfussenegger/nvim-dap
--

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local dap, dapui, dap_virtual_text = require('dap'), require('dapui'), require('nvim-dap-virtual-text')

dapui.setup()
dap_virtual_text.setup()

-- keymaps
keymap('n', '<F5>', dap.continue, opts)
keymap('n', '<F10>', dap.step_over, opts)
keymap('n', '<F11>', dap.step_into, opts)
keymap('n', '<F12>', dap.step_out, opts)
keymap('n', '<Leader>b', dap.toggle_breakpoint, opts)
keymap('n', '<Leader>B', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
keymap(
  'n',
  '<Leader>lp',
  "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
  opts
)
keymap('n', '<Leader>dr', dap.repl.open, opts)
keymap('n', '<Leader>dl', dap.run_last, opts)

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end
