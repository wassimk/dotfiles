--
-- fidget.nvim
-- https://github.com/j-hui/fidget.nvim
--

return {
  'j-hui/fidget.nvim',
  tag = 'legacy',
  config = function()
    require('fidget').setup({
      sources = {
        ['null-ls'] = {
          ignore = true,
        },
      },
    })
  end,
}
