--
-- nvim-autopairs
-- https://github.com/windwp/nvim-autopairs
--

return {
  'windwp/nvim-autopairs',
  config = function()
    local npairs = require('nvim-autopairs')

    npairs.setup({
      check_ts = true,
      map_cr = true,
    })

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
