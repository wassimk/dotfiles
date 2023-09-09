--
-- nvim-insx
-- https://github.com/hrsh7th/nvim-insx
--

return {
  'hrsh7th/nvim-insx',
  config = function()
    require('insx.preset.standard').setup()
  end,
}
