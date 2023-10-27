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
