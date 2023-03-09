--
-- nvim-colorizer
-- https://github.com/NvChad/nvim-colorizer.lua
--

local has_colorizer, colorizer = pcall(require, 'colorizer')

if not has_colorizer then
  return
end

colorizer.setup({
  filetypes = { 'eruby', 'html', 'css', 'scss', 'cmp_menu', 'cmp_docs' },
  user_default_options = {
    tailwind = true,
    always_update = true,
  },
})
