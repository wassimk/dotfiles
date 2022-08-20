--
-- nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui
-- https://github.com/theHamsta/nvim-dap-virtual-text
--

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- dap
local dap = require('dap')

dap.set_log_level('TRACE')

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

-- dapui
local dapui = require('dapui')

dapui.setup({
  mappings = {
    expand = 'o',
    open = 'O',
  },
})

keymap('n', '<Leader>du', dapui.toggle, opts)

-- dap-virtual-text
local dap_virtual_text = require('nvim-dap-virtual-text')

dap_virtual_text.setup()
