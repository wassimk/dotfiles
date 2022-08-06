--
-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim
--

local M = {}

function M.setup()
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('ui-select')
end

return M
