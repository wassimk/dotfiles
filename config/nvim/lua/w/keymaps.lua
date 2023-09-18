--
-- keymaps
--

local function opts(prefix, desc)
  return {
    desc = prefix .. ': ' .. desc,
  }
end

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
vim.keymap.set('n', 't<C-n>', '<cmd>Neotest run<cr>', opts('NEOTEST', 'nearest'))
vim.keymap.set('n', 't<C-f>', '<cmd>Neotest run file<cr>', opts('NEOTEST', 'file'))
vim.keymap.set('n', 't<C-a>', function()
  require('neotest').run.run({ suite = true })
end, opts('NEOTEST', 'suite'))
vim.keymap.set('n', 't<C-l>', '<cmd>Neotest run last<cr>', opts('NEOTEST', 'last'))
vim.keymap.set('n', '<leader>ht', '<cmd>Neotest output<cr>', opts('NEOTEST', 'output float'))
vim.keymap.set('n', 't<C-o>', '<cmd>Neotest output-panel<cr>', opts('NEOTEST', 'output panel'))
vim.keymap.set('n', 't<C-u>', '<cmd>Neotest summary<cr>', opts('NEOTEST', 'summary sidebar'))
