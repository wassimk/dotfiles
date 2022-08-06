--
-- nvim-web-icons.nvim
-- https://github.com/kyazdani42/nvim-web-devicons
--

local M = {}

function M.setup()
  require('nvim-web-devicons').setup({ default = true })
end

return M
