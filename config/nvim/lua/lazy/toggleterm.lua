--
-- toggleterm.nvim
-- https://github.com/akinsho/toggleterm.nvim
--

local M = {}

function M.setup()
  require('toggleterm').setup({
    direction = 'float',
  })
end

return M
