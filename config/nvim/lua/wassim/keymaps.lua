local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Remap leader and local leader to <Space>
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- nvim-tree
keymap('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', opts)

-- vim-test
keymap('n', 't<C-n>', '<cmd>TestNearest<CR>', opts)
keymap('n', 't<C-f>', '<cmd>TestFile<CR>', opts)
keymap('n', 't<C-a>', '<cmd>TestSuite<CR>', opts)
keymap('n', 't<C-l>', '<cmd>TestLast<CR>', opts)
keymap('n', 't<C-g>', '<cmd>TestVisit<CR>', opts)

-- iron.nvim
keymap('n', '<Leader>pl', require('iron.core').send_line, opts)
keymap('v', '<Leader>pv', require('iron.core').visual_send, opts)
keymap('n', '<Leader>pf', require('iron.core').send_file, opts)
keymap('n', '<Leader>pc', require('iron.core').close_repl, opts)
keymap('n', '<Leader>pr', require('iron.core').repl_restart, opts)

-- telescope
keymap('n', '<C-f>', '', opts) -- i keep typing this and it scrolls the screen!
keymap('n', '<C-f>f', '<cmd>Telescope find_files<CR>', opts)
keymap('n', '<C-f>w', '<cmd>Telescope grep_string<CR>', opts)
keymap('n', '<C-f>g', '<cmd>Telescope live_grep<CR>', opts)
keymap('n', '<C-f>b', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
keymap('n', '<C-f>h', '<cmd>Telescope help_tags<CR>', opts)
keymap('n', '<C-f>c', '<cmd>Telescope commands<CR>', opts)
keymap('n', '<C-f>k', '<cmd>Telescope keymaps<CR>', opts)

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
keymap('n', ']b', '<cmd>BufferLineCycleNext<CR>', opts)
keymap('n', '[b', '<cmd>BufferLineCyclePrev<CR>', opts)

-- vim-easy-align
keymap('x', 'ga', '<Plug>(EasyAlign)<CR>', opts)
keymap('n', 'ga', '<Plug>(EasyAlign)<CR>', opts)

-- split resizing (defaults taken over by yabai)
keymap('n', '<M-i>', '<cmd>resize -5<CR>')
keymap('n', '<M-u>', '<cmd>resize +5<CR>')
keymap('n', '<M-y>', '<cmd>vertical resize +5<CR>')
keymap('n', '<M-o>', '<cmd>vertical resize -5<CR>')
