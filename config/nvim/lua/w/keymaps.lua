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

-- iron
vim.keymap.set('n', '<Leader>pl', "<cmd>lua require('iron.core').send_line()<cr>", opts('IRON', 'send line to REPL'))
vim.keymap.set(
  'v',
  '<Leader>pv',
  "<cmd>lua require('iron.core').visual_send()<cr>",
  opts('IRON', 'send line (visual) to REPL')
)
vim.keymap.set('n', '<Leader>pf', "<cmd>lua require('iron.core').send_file()<cr>", opts('IRON', 'send file to REPL'))
vim.keymap.set('n', '<Leader>pc', "<cmd>lua require('iron.core').close_repl()<cr>", opts('IRON', 'close REPL'))
vim.keymap.set('n', '<Leader>pr', "<cmd>lua require('iron.core').repl_restart()<cr>", opts('IRON', 'restart REPL'))

-- vim-easy-align
vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)<cr>', opts('VIM-EASY-ALIGN', 'align'))

-- trouble
vim.keymap.set('n', '<leader>t', '<cmd>TroubleToggle<cr>', opts('TROUBLE', 'toggle window'))

-- apple = red
-- grass += green
-- sky -= blue
