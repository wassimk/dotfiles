--
-- trouble.nvim
-- https://github.com/folke/trouble.nvim
--

local M = {}

function M.setup()
  require('trouble').setup({
    padding = false,
  })
end

return M
