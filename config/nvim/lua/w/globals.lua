local reloader = nil
local ok, plenary_reload = pcall(require, 'plenary.reload')
if not ok then
  reloader = require
else
  reloader = plenary_reload.reload_module
end

P = function(v)
  print(vim.inspect(v))
  return v
end

LOG = function(...)
  local logger = require('plenary.log').new({ plugin = 'globals-log' })
  return logger.info(...)
end

RELOAD = function(...)
  return reloader(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end
