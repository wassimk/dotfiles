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

----
-- Keymaps for Lazy Loaded Plugins
----

-- nvim-tree
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<cr>', opts('FILES', 'toggle file tree'))

-- vim-test
vim.keymap.set('n', 't<C-n>', '<cmd>TestNearest<cr>', opts('VIM-TEST', 'test nearest'))
vim.keymap.set('n', 't<C-f>', '<cmd>TestFile<cr>', opts('VIM-TEST', 'file'))
vim.keymap.set('n', 't<C-a>', '<cmd>TestSuite<cr>', opts('VIM-TEST', 'suite'))
vim.keymap.set('n', 't<C-l>', '<cmd>TestLast<cr>', opts('VIM-TEST', 'last'))
vim.keymap.set('n', 't<C-g>', '<cmd>TestVisit<cr>', opts('VIM-TEST', 'visit'))

-- vim-easy-align
vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)<cr>', opts('VIM-EASY-ALIGN', 'align'))

-- trouble
vim.keymap.set('n', '<leader>t', '<cmd>TroubleToggle<cr>', opts('TROUBLE', 'toggle window'))
