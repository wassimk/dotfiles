--
-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
--

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
