local api = vim.api

-- user command to launch lazygit in a floaterm
api.nvim_create_user_command('Lg', 'FloatermNew lazygit', {})
