--
-- trouble.nvim
-- https://github.com/folke/trouble.nvim
--

return {
  'folke/trouble.nvim',
  cmd = { 'Trouble', 'TroubleToggle' },
  config = function()
    require('trouble').setup({
      padding = false,
    })
  end,
}
