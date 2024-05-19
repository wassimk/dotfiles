--
-- usercmds
--

vim.api.nvim_create_user_command('Lg', function()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({ cmd = 'lazygit', direction = 'float', hidden = true })

  lazygit:toggle()
end, { desc = 'LAZYGIT: launch with toggleterm' })

vim.api.nvim_create_user_command('OpenInGHPR', function(command)
  local arg = command.args
  if arg == '' then
    arg = vim.fn.expand('<cword>')
  end
  local gh_cmd, result

  if tonumber(arg) then
    gh_cmd = 'gh pr view ' .. arg .. ' --json number,title,url'
    result = vim.json.decode(vim.fn.system(gh_cmd))
  else
    gh_cmd = 'gh pr list --search "' .. arg .. '" --state merged --json number,title,url'
    result = vim.json.decode(vim.fn.system(gh_cmd))[1]
  end

  if vim.tbl_isempty(result) then
    print('No PR found')
    return
  end

  vim.ui.open(result.url)
end, { desc = 'Open PR in browser by number, commit sha or search params' })
