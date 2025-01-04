--
-- nvim-rip-substitute
-- https://github.com/chrisgrieser/nvim-rip-substitute
--

return {
  'chrisgrieser/nvim-rip-substitute',
  cmd = 'RipSubstitute',
  keys = {
    {
      '<leader>e',
      function()
        require('rip-substitute').sub()
      end,
      mode = { 'n', 'x' },
      desc = ' rip substitute',
    },
  },
}
