local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- remap leader and local leader to <Space>
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- clipboard
keymap({ 'n', 'v' }, '<Leader>y', '"+y', opts)

-- nvim-tree
keymap('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', opts)

-- vim-test
keymap('n', 't<C-n>', '<cmd>TestNearest<CR>', opts)
keymap('n', 't<C-f>', '<cmd>TestFile<CR>', opts)
keymap('n', 't<C-a>', '<cmd>TestSuite<CR>', opts)
keymap('n', 't<C-l>', '<cmd>TestLast<CR>', opts)
keymap('n', 't<C-g>', '<cmd>TestVisit<CR>', opts)

-- iron
keymap('n', '<Leader>pl', "<cmd>lua require('iron.core').send_line()<CR>", opts)
keymap('v', '<Leader>pv', "<cmd>lua require('iron.core').visual_send()<CR>", opts)
keymap('n', '<Leader>pf', "<cmd>lua require('iron.core').send_file()<CR>", opts)
keymap('n', '<Leader>pc', "<cmd>lua require('iron.core').close_repl()<CR>", opts)
keymap('n', '<Leader>pr', "<cmd>lua require('iron.core').repl_restart()<CR>", opts)

-- telescope
keymap('n', '<C-f>', '', opts) -- i keep hitting this and it scrolls the screen!
keymap('n', '<C-f>f', '<cmd>Telescope find_files<CR>', opts)
keymap('n', '<C-f>w', '<cmd>Telescope grep_string<CR>', opts)
keymap('n', '<C-f>g', '<cmd>Telescope live_grep<CR>', opts)
keymap('n', '<C-f>b', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
keymap('n', '<C-f>h', '<cmd>Telescope help_tags<CR>', opts)
keymap('n', '<C-f>c', '<cmd>Telescope commands<CR>', opts)
keymap('n', '<C-f>k', '<cmd>Telescope keymaps<CR>', opts)

-- vim-easy-align
keymap({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)<CR>', opts)

-- split resizing (defaults taken over by yabai)
keymap('n', '<M-i>', '<cmd>resize -5<CR>')
keymap('n', '<M-u>', '<cmd>resize +5<CR>')
keymap('n', '<M-y>', '<cmd>vertical resize +5<CR>')
keymap('n', '<M-o>', '<cmd>vertical resize -5<CR>')
