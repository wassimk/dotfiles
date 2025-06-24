--
-- claudecode.nvim
-- https://github.com/coder/claudecode.nvim
--

return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = true,
  cmd = {
    'ClaudeCode',
    'ClaudeCodeAdd',
    'ClaudeCodeSend',
  },
  keys = {
    { '<leader>a', nil, desc = '+AI' },
    { '<leader>aa', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree' },
    },
    -- Diff management
    { '<leader>ag', '', mode = { 'n', 'v' }, desc = '+Diff Management' },
    { '<leader>aga', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>agr', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Reject diff' },
  },
}
