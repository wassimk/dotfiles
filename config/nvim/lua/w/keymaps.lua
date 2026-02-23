--
-- keymaps
--

-- clipboard
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', { desc = 'copy to system clipboard' })

-- quickfix
vim.keymap.set('n', '<leader>q', require('w.utils').toggle_qf, { desc = 'toggle quickfix' })
vim.keymap.set('n', '<leader>l', require('w.utils').toggle_loclist, { desc = 'toggle loclist' })

-- messages
vim.keymap.set('n', '<leader>m', '<cmd>MessagesToBuffer<cr>', { desc = 'messages to buffer' })

-- execute current line or file
vim.keymap.set('n', '<leader>x', '<cmd>.lua<CR>', { desc = 'execute current line' })
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'execute current file' })
