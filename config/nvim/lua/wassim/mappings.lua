--------------
-- Key Mappings
--------------

-- custom leader mapping
vim.cmd('let mapleader = "\\<Space>"')

local opts = { silent = true }

-- nvim-tree toggle
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', opts)

-- edit configuration files
vim.keymap.set('n', '<leader>ev', '<cmd>vsplit $MYVIMRC<CR>', opts)
vim.keymap.set('n', '<leader>ez', '<cmd>vsplit ~/.zshrc<CR>', opts)
vim.keymap.set('n', '<leader>et', '<cmd>vsplit ~/.tmux.conf<CR>', opts)
vim.keymap.set('n', '<leader>sv', '<cmd>source $MYVIMRC<CR>', opts)

-- vim-test
vim.keymap.set('n', 't<C-n>', '<cmd>TestNearest<CR>', opts)
vim.keymap.set('n', 't<C-f>', '<cmd>TestFile<CR>', opts)
vim.keymap.set('n', 't<C-a>', '<cmd>TestSuite<CR>', opts)
vim.keymap.set('n', 't<C-l>', '<cmd>TestLast<CR>', opts)
vim.keymap.set('n', 't<C-g>', '<cmd>TestVisit<CR>', opts)

-- telescope
vim.keymap.set('n', '<C-f>f', '<cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', '<C-f>g', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<C-f>b', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
vim.keymap.set('n', '<C-f>ob', '<cmd>Telescope buffers<CR>', opts)
vim.keymap.set('n', '<C-f>h', '<cmd>Telescope help_tags<CR>', opts)
vim.keymap.set('n', '<C-f>c', '<cmd>Telescope commands<CR>', opts)
vim.keymap.set('n', '<C-f>k', '<cmd>Telescope keymaps<CR>', opts)

-- split resizing
vim.keymap.set('n', '<M-k>', '<cmd>resize -5<CR>')
vim.keymap.set('n', '<M-j>', '<cmd>resize +5<CR>')
vim.keymap.set('n', '<M-h>', '<cmd>vertical resize -5<CR>')
vim.keymap.set('n', '<M-l>', '<cmd>vertical resize +5<CR>')

local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-y>'] = actions.select_default
      },
      n = {
        ['<C-y>'] = actions.select_default
      },
    },
  }
}
-- bufferline
vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<CR>', opts)
vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<CR>', opts)
