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

-- neotest
local has_neotest, neotest = pcall(require, 'neotest')
if has_neotest then
  vim.keymap.set('n', 't<C-n>', neotest.run.run, opts('NEOTEST', 'nearest'))

  vim.keymap.set('n', 't<C-f>', function()
    neotest.run.run(vim.fn.expand('%'))
  end, opts('NEOTEST', 'file'))

  vim.keymap.set('n', 't<C-a>', function()
    neotest.run.run({ suite = true })
  end, opts('NEOTEST', 'suite'))

  vim.keymap.set('n', 't<C-l>', neotest.run.run_last, opts('NEOTEST', 'last'))
  vim.keymap.set('n', '<leader>ht', function()
    neotest.output.open({ short = true })
  end, opts('NEOTEST', 'output float'))
  vim.keymap.set('n', 't<C-o>', neotest.output_panel.toggle, opts('NEOTEST', 'output panel'))
  vim.keymap.set('n', 't<C-u>', neotest.summary.toggle, opts('NEOTEST', 'summary sidebar'))
end
