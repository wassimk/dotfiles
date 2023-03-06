--
-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
--

local M = {}

function M.setup()
  require('nvim-tree').setup({
    view = {
      hide_root_folder = false,
    },
  })
end

return M
