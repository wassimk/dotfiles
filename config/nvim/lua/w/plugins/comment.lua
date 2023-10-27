--
-- Comment.nvim
-- https://github.com/numToStr/Comment.nvim
--

return {
  'numToStr/Comment.nvim',
  version = '*',
  keys = {
    {
      'gc',
      mode = 'v',
      desc = 'Comment visual lines',
    },
    {
      'gb',
      mode = 'v',
      desc = 'Comment visual block',
    },
    {
      'gcc',
      mode = 'n',
      desc = 'Comment line',
    },
    {
      'gbc',
      mode = 'n',
      desc = 'Comment block',
    },
  },
  config = true,
}
