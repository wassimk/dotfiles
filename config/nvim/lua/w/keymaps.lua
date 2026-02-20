--
-- keymaps
--

local function opts(prefix, desc)
  return {
    desc = prefix .. ': ' .. desc,
  }
end

-- clipboard
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', opts('clipboard', 'copy to system'))

-- quickfix
vim.keymap.set('n', '<leader>q', require('w.utils').toggle_qf, opts('quickfix', 'toggle'))
vim.keymap.set('n', '<leader>l', require('w.utils').toggle_loclist, opts('loclist', 'toggle'))

-- execute current line or file
vim.keymap.set('n', '<leader>x', '<cmd>.lua<CR>', opts('', 'Execute the current line'))
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>', opts('', 'Execute the current file'))
