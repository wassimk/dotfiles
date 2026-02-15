--
-- autocmds
--

local api = vim.api
local wamGrp = api.nvim_create_augroup('WamAutocmds', {})

-- highlight on yank
api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
  group = wamGrp,
})

-- show/hide diagnostics based on active window
api.nvim_create_autocmd({ 'FocusGained', 'WinEnter' }, {
  callback = function()
    if vim.bo.filetype == 'lazy' then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.show(nil, bufnr)
  end,
  group = wamGrp,
})

api.nvim_create_autocmd({ 'FocusLost', 'WinLeave' }, {
  callback = function()
    if vim.bo.filetype == 'lazy' then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.hide(nil, bufnr)
  end,
  group = wamGrp,
})

-- show cursor line only in active window
api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  callback = function()
    vim.wo.cursorline = true
  end,
  group = wamGrp,
})

api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  callback = function()
    vim.wo.cursorline = false
  end,
  group = wamGrp,
})

api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'Brewfile*',
  callback = function()
    vim.bo.filetype = 'conf'
  end,
  group = wamGrp,
})

-- close certain windows with "q"
api.nvim_create_autocmd('FileType', {
  pattern = {
    'git',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'qf',
    'vim', -- for the q: popup
    'query', -- :InspectTree
    'startuptime',
    'dap-float',
  },
  callback = function()
    vim.keymap.set('n', 'q', ':close<cr>', { buffer = true, silent = true })
  end,
  group = wamGrp,
})

api.nvim_create_autocmd('FileType', {
  pattern = 'man',
  callback = function()
    vim.keymap.set('n', 'q', ':quit<cr>', { buffer = true, silent = true })
  end,
  group = wamGrp,
})

-- new lines with 'o' or 'O' from commented lines don't continue commenting
api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.opt_local.formatoptions:remove('o')
  end,
  group = wamGrp,
})

-- try linting via nvim-lint on save
api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
  callback = function()
    require('lint').try_lint()
  end,
  group = wamGrp,
})
