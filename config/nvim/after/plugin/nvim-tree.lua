--
-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
--

if packer_plugins['nvim-tree.lua'] and packer_plugins['nvim-tree.lua'].loaded then
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
