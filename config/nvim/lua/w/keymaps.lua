--
-- keymaps
--

local function opts(prefix, desc)
  return {
    desc = prefix .. ': ' .. desc,
  }
end

-- remap leader and local leader to <Space>
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- clipboard
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', opts('CLIPBOARD', 'copy to system'))

-- quickfix
vim.keymap.set('n', '<leader>q', require('w.utils').toggle_qf, opts('QUICKFIX', 'toggle'))
vim.keymap.set('n', '<leader>l', require('w.utils').toggle_loclist, opts('LOCLIST', 'toggle'))

----
-- Keymaps for Lazy Loaded Plugins
----

-- nvim-tree
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<cr>', opts('FILES', 'toggle file tree'))

-- sort.nvim
vim.keymap.set('n', 'gs', '<cmd>Sort<cr>', { desc = 'SORT: sort line(s)' })
vim.keymap.set('x', 'gs', '<esc><cmd>Sort<cr>', { desc = 'SORT: sort visual selection' })

-- toggleterm
vim.keymap.set('n', '<C-Bslash>', '<cmd>ToggleTerm<cr>', opts('TOGGLETERM', 'toggle terminal'))

-- trouble
vim.keymap.set('n', '<leader>t', '<cmd>TroubleToggle<cr>', opts('TROUBLE', 'toggle window'))

-- vim-easy-align
vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)<cr>', opts('VIM-EASY-ALIGN', 'align'))

-- vim-test
vim.keymap.set('n', 't<C-n>', '<cmd>TestNearest<cr>', opts('VIM-TEST', 'test nearest'))
vim.keymap.set('n', 't<C-f>', '<cmd>TestFile<cr>', opts('VIM-TEST', 'file'))
vim.keymap.set('n', 't<C-a>', '<cmd>TestSuite<cr>', opts('VIM-TEST', 'suite'))
vim.keymap.set('n', 't<C-l>', '<cmd>TestLast<cr>', opts('VIM-TEST', 'last'))
vim.keymap.set('n', 't<C-g>', '<cmd>TestVisit<cr>', opts('VIM-TEST', 'visit'))
