--
-- usercmds
--

vim.api.nvim_create_user_command('Lg', function()
  require('snacks').lazygit.open()
end, { desc = 'lazygit: launch with toggleterm' })

vim.api.nvim_create_user_command('LspFormat', function()
  vim.lsp.buf.format()
end, { desc = 'lsp: format with language servers' })

vim.api.nvim_create_user_command('MessagesToBuffer', function()
  local buf = vim.api.nvim_create_buf(false, true)
  local messages = vim.split(vim.api.nvim_exec2('messages', { output = true }).output, '\n')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, messages)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'
  vim.api.nvim_open_win(buf, true, { split = 'below' })
  vim.cmd('normal! G')
end, { desc = 'Open :messages in a scratch buffer' })
