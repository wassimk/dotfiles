local api = vim.api
local wamGrp = api.nvim_create_augroup('WamAutocmds', { clear = true })

-- Highlight on yank
api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  command = 'silent! lua vim.highlight.on_yank { timeout = 750 }',
  group = wamGrp,
})

-- Wrap long text in quickfix windows
api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  command = 'setlocal wrap',
  group = wamGrp,
})

-- Center current window when is resized
-- FIXME: this doesn't seem to work, you can manally do it and it behaves different
api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  command = 'execute "normal! \\<c-w>="',
  group = wamGrp,
})

-- markdown
api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  command = 'setlocal spell | setlocal textwidth=100',
  group = wamGrp,
})

-- gitcommit
api.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit',
  command = 'setlocal spell',
  group = wamGrp,
})
