--
-- scalpel.nvim
-- https://www.github.com/wassimk/scalpel.nvim
--

return {
  'wassimk/scalpel.nvim',
  version = '*',
  config = true,
  dev = true,
  keys = {
    {
      '<leader>e',
      function()
        require('scalpel').substitute()
      end,
      mode = { 'n', 'x' },
      desc = 'substitute word(s)',
    },
  },
}
