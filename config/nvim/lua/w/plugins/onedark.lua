--
-- onedark.nvim
-- https://github.com/navarasu/onedark.nvim
--

return {
  'navarasu/onedark.nvim',
  priority = 1000,
  config = function()
    require('onedark').setup({
      style = 'darker',
    })

    require('onedark').load()
  end,
}
