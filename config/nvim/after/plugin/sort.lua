--
-- sort.nvim
-- https://github.com/sQVe/sort.nvim
--

require('sort').setup()

vim.keymap.set('n', 'gs', '<cmd>Sort<cr>', { desc = 'SORT: sort line(s)' })
vim.keymap.set('x', 'gs', '<esc><cmd>Sort<cr>', { desc = 'SORT: sort visual selection' })
