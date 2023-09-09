--
-- nvim-colorizer
-- https://github.com/NvChad/nvim-colorizer.lua
--

return {
  'NvChad/nvim-colorizer.lua',
  opts = {
    filetypes = { 'eruby', 'html', 'css', 'scss', 'cmp_menu', 'cmp_docs' },
    user_default_options = {
      tailwind = true,
      always_update = true,
    },
  },
}
