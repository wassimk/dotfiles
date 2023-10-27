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
      desc = 'SORT: under cursor',
    },
    {
      'gs',
      '<esc><cmd>Sort<cr>',
      mode = 'v',
      desc = 'SORT: sort visual lines',
    },
  },
  config = true,
}
