local M = {}

function M.installed_via_bundler(gemname)
  local gemfile = M.root_dir_of_git_repo() .. 'Gemfile.lock'

  if vim.fn.filereadable(gemfile) == 0 then
    return
  end

  local found = false
  for line in io.lines(gemfile) do
    if string.find(line, gemname) then
      found = true
      break
    end
  end

  return found
end

function M.config_exists(filename)
  local file = M.root_dir_of_git_repo() .. filename

  return vim.fn.filereadable(file) == 1
end

function M.root_dir_of_git_repo()
  local root_dir = vim.fs.find('.git', { type = 'directory' })

  if root_dir then
    return root_dir[1]:gsub('%.git', '')
  else
    return './'
  end
end

function M.is_dir(filename)
  return M.exists(filename) == 'directory'
end

function M.is_file(filename)
  return M.exists(filename) == 'file'
end

function M.exists(filename)
  local stat = vim.loop.fs_stat(filename)
  return stat and stat.type or false
end

return M
