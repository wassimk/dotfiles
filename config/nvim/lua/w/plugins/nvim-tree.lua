--
-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
--

return {
  'kyazdani42/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  opts = {
    view = {
      hide_root_folder = false,
      width = {
        min = 40,
        max = -2,
        padding = 1,
      },
    },
  },
}
