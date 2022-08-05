--
-- vim-floaterm
-- https://github.com/voldikss/vim-floaterm
--

if packer_plugins['vim-floaterm'] and packer_plugins['vim-floaterm'].loaded then
  vim.g.floaterm_width = 0.85
  vim.g.floaterm_height = 0.85
  vim.g.floaterm_title = ''

  -- user command to launch lazygit in a floaterm
  vim.api.nvim_create_user_command('Lg', 'FloatermNew lazygit', {})
end
