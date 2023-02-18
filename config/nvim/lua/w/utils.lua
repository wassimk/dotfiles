local M = {}

function M.installed_via_bundler(gemname)
  local gemfile = vim.fs.find('Gemfile.lock')[1]

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
  local file = vim.fs.find(filename)[1]

  return vim.fn.filereadable(file) == 1
end
return M
