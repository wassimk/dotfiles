--------------
-- Key Mappings
--------------

-- custom leader mapping
vim.cmd('let mapleader = "\\<Space>"')

-- nvim-tree toggle
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Edit configuration files
vim.api.nvim_set_keymap('n', '<Leader>ev', ':vsplit $MYVIMRC<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ez', ':vsplit ~/.zshrc<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>et', ':vsplit ~/.tmux.conf<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sv', ':source $MYVIMRC<CR>', { silent = true })

-- vim-test mappings
vim.api.nvim_set_keymap('n', 't<C-n>', ':TestNearest<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-f>', ':TestFile<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-a>', ':TestSuite<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-l>', ':TestLast<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-g>', ':TestVisit<CR>', { silent = true })

-- telescope mappings
vim.api.nvim_set_keymap('n', '<C-f>f', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>g', ':Telescope live_grep<CR>', { noremap = tru, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>b', ':Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>ob', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>h', ':Telescope help_tags<CR>', { noremap = true, silent = true })
