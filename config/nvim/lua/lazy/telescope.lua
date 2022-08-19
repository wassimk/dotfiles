--
-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim
--

local M = {}

function M.setup()
  local telescope, actions = require('telescope'), require('telescope.actions')

  telescope.load_extension('dap')
  telescope.load_extension('fzf')
  telescope.load_extension('ui-select')

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ['<C-y>'] = actions.select_default,
          ['<C-e>'] = actions.close,
        },
        n = {
          ['<C-y>'] = actions.select_default,
          ['<C-e>'] = actions.close,
        },
      },
    },
  })
end

return M
