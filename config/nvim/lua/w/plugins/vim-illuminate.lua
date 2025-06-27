--
-- vim-illuminate
-- https://github.com/rrethy/vim-illuminate
--

return {
  'rrethy/vim-illuminate',
  config = function()
    require('illuminate').configure({
      providers = {
        'lsp',
        'treesitter',
        'regex',
      },
    })
  end,
}
