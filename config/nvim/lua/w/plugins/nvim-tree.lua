--
-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
--

return {
  'kyazdani42/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  keys = {
    { '<C-n>', '<cmd>NvimTreeToggle<cr>', mode = 'n', desc = 'FILES: toggle file tree' },
  },
  opts = {
    view = {
      width = {
        min = 40,
        max = -2,
      },
    },
  },
}
