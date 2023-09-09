--
-- onedark.nvim
-- https://github.com/navarasu/onedark.nvim
--

return {
  'navarasu/onedark.nvim',
  config = function()
    require('onedark').setup({
      style = 'darker',
    })

    require('onedark').load()
  end,
}
