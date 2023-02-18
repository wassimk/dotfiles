--
-- ruby qf
--

-- wrap long text in quickfix windows
vim.opt_local.wrap = true

-- use ESC to close qf window
vim.keymap.set('n', '<Esc>', '<cmd>cclose<bar>lclose<CR>', { noremap = true, silent = true })