--
-- toggleterm.nvim
-- https://github.com/akinsho/toggleterm.nvim
--

require('toggleterm').setup({
  open_mapping = '<c-\\>',
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*',
  callback = function()
    local opts = { buffer = 0 }

    vim.keymap.set('t', '<esc>', '<C-\\><C-n>', opts)
    vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', opts)
    vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', opts)
    vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', opts)
    vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', opts)
  end,
  group = vim.api.nvim_create_augroup('WamTerminalKeymaps', {}),
})
