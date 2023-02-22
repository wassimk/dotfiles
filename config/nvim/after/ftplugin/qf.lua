--
-- qf filetype
--

-- wrap long text in quickfix windows
vim.opt_local.wrap = true

-- use ESC to close qf window
vim.keymap.set('n', '<Esc>', '<cmd>cclose<bar>lclose<cr>', { noremap = true, silent = true })
