--------------
-- Key Mappings
--------------

vim.g.mapleader = ' '

local opts = { silent = true }

-- nvim-tree
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', opts)

-- vim-test
vim.keymap.set('n', 't<C-n>', '<cmd>TestNearest<CR>', opts)
vim.keymap.set('n', 't<C-f>', '<cmd>TestFile<CR>', opts)
vim.keymap.set('n', 't<C-a>', '<cmd>TestSuite<CR>', opts)
vim.keymap.set('n', 't<C-l>', '<cmd>TestLast<CR>', opts)
vim.keymap.set('n', 't<C-g>', '<cmd>TestVisit<CR>', opts)

-- iron.nvim
vim.keymap.set('n', '<Leader>pl', require('iron.core').send_line, opts)
vim.keymap.set('v', '<Leader>pv', require('iron.core').visual_send, opts)
vim.keymap.set('n', '<Leader>pf', require('iron.core').send_file, opts)
vim.keymap.set('n', '<Leader>pc', require('iron.core').close_repl, opts)
vim.keymap.set('n', '<Leader>pr', require('iron.core').repl_restart, opts)

-- telescope
vim.keymap.set('n', '<C-f>f', '<cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', '<C-f>w', '<cmd>Telescope grep_string<CR>', opts)
vim.keymap.set('n', '<C-f>g', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<C-f>b', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
vim.keymap.set('n', '<C-f>h', '<cmd>Telescope help_tags<CR>', opts)
vim.keymap.set('n', '<C-f>c', '<cmd>Telescope commands<CR>', opts)
vim.keymap.set('n', '<C-f>k', '<cmd>Telescope keymaps<CR>', opts)

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-y>'] = require('telescope.actions').select_default,
        ['<C-e>'] = require('telescope.actions').close,
      },
      n = {
        ['<C-y>'] = require('telescope.actions').select_default,
        ['<C-e>'] = require('telescope.actions').close,
      },
    },
  },
})

-- bufferline.nvim
vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<CR>', opts)
vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<CR>', opts)

-- vim-easy-align
vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)<CR>', opts)
vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)<CR>', opts)

-- split resizing (defaults taken over by yabai)
vim.keymap.set('n', '<M-i>', '<cmd>resize -5<CR>')
vim.keymap.set('n', '<M-u>', '<cmd>resize +5<CR>')
vim.keymap.set('n', '<M-y>', '<cmd>vertical resize +5<CR>')
vim.keymap.set('n', '<M-o>', '<cmd>vertical resize -5<CR>')
