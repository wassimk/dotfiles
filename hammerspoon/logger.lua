--
-- Simple logging facility.
--
local logLevel = "info" -- generally want 'debug' or 'info'
local log = hs.logger.new("WAM", logLevel)

return { i = log.i, df = log.df, wf = log.wf }
