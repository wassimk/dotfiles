local api = vim.api
local wamGrp = api.nvim_create_augroup('WamAutocmds', {})

-- wrap long text in quickfix windows
api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  command = 'setlocal wrap',
  group = wamGrp,
})

-- markdown
api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  command = 'setlocal spell | setlocal textwidth=100',
  group = wamGrp,
})

-- show cursor line only in active window
api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  command = 'set cursorline',
  group = wamGrp,
})

api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  command = 'set nocursorline',
  group = wamGrp,
})

-- close certain windows to close with "q"
api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'startuptime', 'qf', 'lspinfo' },
  command = 'nnoremap <buffer><silent> q :close<CR>',
  group = wamGrp,
})

api.nvim_create_autocmd('FileType', {
  pattern = 'man',
  command = 'nnoremap <buffer><silent> q :quit<CR>',
  group = wamGrp,
})

-- new lines with 'o' or 'O' from commented lines don't continue commenting
api.nvim_create_autocmd('FileType', {
  command = 'setlocal formatoptions-=o',
  group = wamGrp,
})
