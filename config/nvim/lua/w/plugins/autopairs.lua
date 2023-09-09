--
-- nvim-autopairs
-- https://github.com/windwp/nvim-autopairs
--

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require('nvim-autopairs')

    npairs.setup({
      check_ts = true,
      map_cr = true,
    })
  end,
}
