--
-- usercmds
--

vim.api.nvim_create_user_command('Lg', function()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true })
  lazygit:toggle()
end, { desc = 'LAZYGIT: launch with floaterm' })
