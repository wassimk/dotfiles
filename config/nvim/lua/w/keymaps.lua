local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- remap leader and local leader to <Space>
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- clipboard
keymap({ 'n', 'v' }, '<Leader>y', '"+y', opts)

----
-- Keymaps for Lazy Loaded Plugins
----

-- nvim-tree
keymap('n', '<C-n>', '<cmd>NvimTreeToggle<cr>', opts)

-- vim-test
keymap('n', 't<C-n>', '<cmd>TestNearest<cr>', opts)
keymap('n', 't<C-f>', '<cmd>TestFile<cr>', opts)
keymap('n', 't<C-a>', '<cmd>TestSuite<cr>', opts)
keymap('n', 't<C-l>', '<cmd>TestLast<cr>', opts)
keymap('n', 't<C-g>', '<cmd>TestVisit<cr>', opts)

-- iron
keymap('n', '<Leader>pl', "<cmd>lua require('iron.core').send_line()<cr>", opts)
keymap('v', '<Leader>pv', "<cmd>lua require('iron.core').visual_send()<cr>", opts)
keymap('n', '<Leader>pf', "<cmd>lua require('iron.core').send_file()<cr>", opts)
keymap('n', '<Leader>pc', "<cmd>lua require('iron.core').close_repl()<cr>", opts)
keymap('n', '<Leader>pr', "<cmd>lua require('iron.core').repl_restart()<cr>", opts)

-- vim-easy-align
keymap({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)<cr>', opts)
