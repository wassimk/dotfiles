--
-- usercmds
--

vim.api.nvim_create_user_command('Lg', function()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({ cmd = 'lazygit', direction = 'float', hidden = true })

  lazygit:toggle()
end, { desc = 'LAZYGIT: launch with toggleterm' })

vim.api.nvim_create_user_command('LspFormat', function()
  vim.lsp.buf.format()
end, { desc = 'LSP: format with language servers' })
