--
-- indent-blankline.nvim
-- https://github.com/lukas-reineke/indent-blankline.nvim
--

if packer_plugins['indent-blankline.nvim'] and packer_plugins['indent-blankline.nvim'].loaded then
  require('indent_blankline').setup({
    show_current_context = false,
  })
end
