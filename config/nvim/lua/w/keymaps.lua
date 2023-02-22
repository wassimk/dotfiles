local function opts(prefix, desc)
  return {
    noremap = true,
    silent = true,
    desc = prefix .. ': ' .. desc,
  }
end

-- remap leader and local leader to <Space>
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
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
vim.keymap.set('n', 't<C-n>', '<cmd>TestNearest<cr>', opts('TEST', 'test nearest'))
vim.keymap.set('n', 't<C-f>', '<cmd>TestFile<cr>', opts('TEST', 'file'))
vim.keymap.set('n', 't<C-a>', '<cmd>TestSuite<cr>', opts('TEST', 'suite'))
vim.keymap.set('n', 't<C-l>', '<cmd>TestLast<cr>', opts('TEST', 'last'))
vim.keymap.set('n', 't<C-g>', '<cmd>TestVisit<cr>', opts('TEST', 'visit'))

-- iron
vim.keymap.set('n', '<Leader>pl', "<cmd>lua require('iron.core').send_line()<cr>", opts('REPL', 'send line'))
vim.keymap.set('v', '<Leader>pv', "<cmd>lua require('iron.core').visual_send()<cr>", opts('REPL', 'send line (visual)'))
vim.keymap.set('n', '<Leader>pf', "<cmd>lua require('iron.core').send_file()<cr>", opts('REPL', 'send file'))
vim.keymap.set('n', '<Leader>pc', "<cmd>lua require('iron.core').close_repl()<cr>", opts('REPL', 'close'))
vim.keymap.set('n', '<Leader>pr', "<cmd>lua require('iron.core').repl_restart()<cr>", opts('REPL', 'restart'))

-- vim-easy-align
vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)<cr>', opts('MOTION', 'align'))

-- trouble
vim.keymap.set('n', '<leader>t', '<cmd>TroubleToggle<cr>', opts('TROUBLE', 'toggle window'))

-- apple = red
-- grass += green
-- sky -= blue
