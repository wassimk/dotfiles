--
-- nvim-insx
-- https://github.com/hrsh7th/nvim-insx
--

local has_insx, _ = pcall(require, 'insx')
if not has_insx then
  return
end

require('insx.preset.standard').setup()
