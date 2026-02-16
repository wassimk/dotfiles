--
-- sort.nvim
-- https://github.com/sQVe/sort.nvim
--

return {
  'sQVe/sort.nvim',
  cmd = 'Sort',
  keys = {
    {
      'gs',
      '<cmd>Sort<cr>',
      mode = 'n',
      desc = 'sort: under cursor',
    },
    {
      'gs',
      '<esc><cmd>Sort<cr>',
      mode = 'v',
      desc = 'sort: sort visual lines',
    },
  },
  config = true,
}
