--
-- claude-code.nvim
-- https://github.com/greggh/claude-code.nvim
--

return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for git operations
  },
  config = {
    window = {
      split_ratio = 0.4,
      position = 'vertical',
    },
  },
}
