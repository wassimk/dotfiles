--
-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
--

local M = {}

function M.setup()
  require('nvim-tree').setup({
    view = {
      hide_root_folder = false,
      mappings = {
        list = {
          { key = '?', action = 'toggle_help' },
        },
      },
    },
  })
end

return M
