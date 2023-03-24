--
-- utils
--

local M = {}

function M.installed_via_bundler(gemname)
  local gemfile = vim.fn.getcwd() .. '/Gemfile'

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

function M.toggle_loclist()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win['loclist'] == 1 then
      vim.cmd('lclose')
      return
    end
  end

  if next(vim.fn.getloclist(0)) == nil then
    vim.notify('location list empty', vim.log.levels.WARN)
    return
  end
  vim.cmd('lopen')
end

return M
