--
-- scalpel
-- https://github.com/wassimk/scalpel.nvim
--

return {
  'wassimk/scalpel.nvim',
  dev = true,
  config = true,
  keys = {
    {
      '<leader>r',
      function()
        require('scalpel').substitute()
      end,
      mode = { 'n', 'x' },
      desc = 'substitute word(s)',
    },
  },
}
