--
-- glow
-- https://github.com/ellisonleao/glow.nvim
--

return {
  'ellisonleao/glow.nvim',
  cmd = 'Glow',
  config = function()
    require('glow').setup({
      width = 105,
    })
  end,
}
