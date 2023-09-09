--
-- indent-blankline.nvim
-- https://github.com/lukas-reineke/indent-blankline.nvim
--

return {
  'lukas-reineke/indent-blankline.nvim',
  version = '*',
  config = function()
    require('indent_blankline').setup({
      show_current_context = false,
    })
  end,
}
