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

-- terminal
vim.keymap.set('t', '<Esc>', '<Esc><C-\\><C-n><C-w>q', { desc = 'Quit and close terminal' })

-- quickfix
vim.keymap.set('n', '<leader>q', require('w.utils').toggle_qf, opts('QUICKFIX', 'toggle'))
vim.keymap.set('n', '<leader>l', require('w.utils').toggle_loclist, opts('LOCLIST', 'toggle'))

-- substitute current word in file
vim.keymap.set('n', '<leader>e', require('w.utils').substitute_current_word, opts('', 'Substite current word in file'))

-- clear highlights with <CR>
vim.keymap.set('n', '<CR>', function()
  if vim.opt.hlsearch:get() then
    vim.cmd.nohl()
    return ''
  else
    return '<CR>'
  end
end, opts('', 'Clear search highlights'))
