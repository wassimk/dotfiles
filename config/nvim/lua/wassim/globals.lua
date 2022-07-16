P = function(v)
  print(vim.inspect(v))
  return v
end

LOG = function(...)
  logger = require('plenary.log').new({ plugin = 'globals-log' })
  return logger.info(...)
end

RELOAD = function(...)
  return require('plenary.reload').reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end
