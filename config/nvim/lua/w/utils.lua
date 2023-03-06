--
-- utils
--

local M = {}

function M.installed_via_bundler(gemname)
  local gemfile_lock = vim.fn.getcwd() .. '/Gemfile.lock'

  if vim.fn.filereadable(gemfile_lock) == 0 then
    return
  end

  local found = false
  for line in io.lines(gemfile_lock) do
    if string.find(line, gemname) then
      found = true
      break
    end
  end

  return found
end

function M.config_exists(filename)
  local file = vim.fn.getcwd() .. '/' .. filename

  return vim.fn.filereadable(file) == 1
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

function M.toggle_qf()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd('cclose')
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd('copen')
  else
    vim.notify('quickfix list is empty', vim.log.levels.WARN)
  end
end

return M
