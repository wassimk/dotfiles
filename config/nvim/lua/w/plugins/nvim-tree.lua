--
-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
--

return {
  'kyazdani42/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  opts = {
    view = {
      width = {
        min = 40,
        max = -2,
      },
    },
  },
}
