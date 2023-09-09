--
-- nvim-colorizer
-- https://github.com/NvChad/nvim-colorizer.lua
--

return {
  'NvChad/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup({
      filetypes = { 'eruby', 'html', 'css', 'scss', 'cmp_menu', 'cmp_docs' },
      user_default_options = {
        tailwind = true,
        always_update = true,
      },
    })
  end,
}
