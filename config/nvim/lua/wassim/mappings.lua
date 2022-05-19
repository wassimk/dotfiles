--------------
-- Key Mappings
--------------

-- custom leader mapping
vim.cmd('let mapleader = "\\<Space>"')

-- nvim-tree toggle
vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Edit configuration files
vim.api.nvim_set_keymap('n', '<Leader>ev', '<cmd>vsplit $MYVIMRC<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ez', '<cmd>vsplit ~/.zshrc<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>et', '<cmd>vsplit ~/.tmux.conf<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sv', '<cmd>source $MYVIMRC<CR>', { silent = true })

-- vim-test mappings
vim.api.nvim_set_keymap('n', 't<C-n>', '<cmd>TestNearest<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-f>', '<cmd>TestFile<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-a>', '<cmd>TestSuite<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-l>', '<cmd>TestLast<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 't<C-g>', '<cmd>TestVisit<CR>', { silent = true })

-- telescope mappings
vim.api.nvim_set_keymap('n', '<C-f>f', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>g', '<cmd>Telescope live_grep<CR>', { noremap = tru, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>b', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>ob', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>h', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })

-- bufferline
vim.api.nvim_set_keymap('n', ']b', '<cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[b', '<cmd>BufferLineCyclePrev<CR>', { noremap = true, silent = true })
