--
-- nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
--

return {
  'kyazdani42/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  config = function()
    require('nvim-tree').setup({
      view = {
        hide_root_folder = false,
      },
    })
  end,
}
