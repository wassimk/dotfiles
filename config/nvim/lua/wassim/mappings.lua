--------------
-- Key Mappings
--------------

-- custom leader mapping
vim.cmd('let mapleader = "\\<Space>"')

-- NERDTree toggle
vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

-- Edit configuration files
vim.api.nvim_set_keymap('n', '<Leader>ev', ':vsplit $MYVIMRC<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>ez', ':vsplit ~/.zshrc<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>et', ':vsplit ~/.tmux.conf<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>sv', ':source $MYVIMRC<CR>', {})

-- vim-test mappings
vim.api.nvim_set_keymap('n', 't<C-n>', ':TestNearest<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-f>', ':TestFile<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-a>', ':TestSuite<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-l>', ':TestLast<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-g>', ':TestVisit<CR>', { silent = true })
