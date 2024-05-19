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

  local gh_cmd, url

  if tonumber(arg) then
    gh_cmd = 'gh pr view ' .. arg .. ' --json url'
    local result = vim.fn.system(gh_cmd)

    if not string.find(result, 'Could not resolve') then
      url = vim.json.decode(result).url
    end
  else
    gh_cmd = 'gh pr list --search "' .. arg .. '" --state merged --json url'
    local result = vim.json.decode(vim.fn.system(gh_cmd))

    if not vim.tbl_isempty(result) then
      url = result[1].url
    end
  end

  if url == nil then
    vim.notify('No PR found for: ' .. arg, vim.log.INFO, { title = ':OpenInGHPR' })
  else
    vim.ui.open(url)
  end
end, { nargs = 1, desc = 'Open PR in browser with number, commit sha or search terms' })
