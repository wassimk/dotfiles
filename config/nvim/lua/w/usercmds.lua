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

  if tonumber(arg) then
    local gh_cmd = 'gh pr view ' .. arg .. ' --json url'
    local result = vim.fn.system(gh_cmd)

    if not string.find(result, 'Could not resolve') then
      vim.ui.open(vim.json.decode(result).url)
    else
      vim.notify('PR #' .. arg .. ' not found', vim.log.INFO, { title = ':OpenInGHPR' })
    end
  else
    local gh_cmd = 'gh pr list --search "' .. arg .. '" --state merged --json number,title,author,url'
    local results = vim.json.decode(vim.fn.system(gh_cmd))

    if vim.tbl_count(results) == 1 then
      vim.ui.open(results[1].url)
    elseif vim.tbl_count(results) > 1 then
      vim.ui.select(results, {
        prompt = 'Select a PR:',
        format_item = function(pr)
          local author = ''
          if pr.author.name then
            author = pr.author.name
          else
            author = 'Unknown Author'
          end

          return '#' .. tostring(pr.number) .. ' ' .. pr.title .. ' - ' .. author
        end,
      }, function(choice)
        vim.ui.open(choice.url)
      end)
    else
      vim.notify('No PR found for: ' .. arg, vim.log.INFO, { title = ':OpenInGHPR' })
    end
  end
end, { nargs = 1, desc = 'Open PR in browser with number, commit sha or search terms' })
