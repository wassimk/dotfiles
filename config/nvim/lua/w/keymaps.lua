--
-- keymaps
--

-- clipboard
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', { desc = 'copy to system clipboard' })

-- search (center only when jumping outside viewport)
local function search_center(cmd)
  local top = vim.fn.line('w0')
  local bot = vim.fn.line('w$')
  vim.cmd('normal! ' .. cmd)
  if vim.fn.line('.') < top or vim.fn.line('.') > bot then
    vim.cmd('normal! zz')
  end
end
vim.keymap.set('n', 'n', function() search_center('n') end, { desc = 'next match' })
vim.keymap.set('n', 'N', function() search_center('N') end, { desc = 'previous match' })
vim.keymap.set('n', '<leader>n', '<cmd>nohlsearch<CR>', { desc = 'clear search highlight' })

-- quickfix
vim.keymap.set('n', '<leader>q', require('w.utils').toggle_qf, { desc = 'toggle quickfix' })
vim.keymap.set('n', '<leader>l', require('w.utils').toggle_loclist, { desc = 'toggle loclist' })

-- messages
vim.keymap.set('n', '<leader>m', '<cmd>MessagesToBuffer<cr>', { desc = 'messages to buffer' })

-- execute current line or file
vim.keymap.set('n', '<leader>x', '<cmd>.lua<CR>', { desc = 'execute current line' })
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'execute current file' })
