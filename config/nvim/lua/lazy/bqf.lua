--
-- nvim-bqf
-- https://github.com/kevinhwang91/nvim-bqf
--

local M = {}

function M.setup()
  require('bqf').setup({
    auto_resize_height = true,
  })
end

return M
