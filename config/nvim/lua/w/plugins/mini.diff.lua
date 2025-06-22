--
-- mini.diff
-- https://github.com/echasnovski/mini.diff
--

return {
  'echasnovski/mini.diff',
  config = function()
    local diff = require('mini.diff')
    diff.setup({
      -- Disabled by default, codecompanion.nvim will call it
      source = diff.gen_source.none(),
    })
  end,
}
