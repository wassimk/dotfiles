--
-- vim-floaterm
-- https://github.com/voldikss/vim-floaterm
--

vim.g.floaterm_width = 0.85
vim.g.floaterm_height = 0.85
vim.g.floaterm_title = ''

-- user command to launch lazygit in a floaterm
vim.api.nvim_create_user_command('Lg', 'FloatermNew lazygit', {})
