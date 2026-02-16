--
-- usercmds
--

vim.api.nvim_create_user_command('Lg', function()
  require('snacks').lazygit.open()
end, { desc = 'lazygit: launch with toggleterm' })

vim.api.nvim_create_user_command('LspFormat', function()
  vim.lsp.buf.format()
end, { desc = 'lsp: format with language servers' })
