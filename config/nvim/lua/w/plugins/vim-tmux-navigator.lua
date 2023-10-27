--
-- vim-tmux-navigator
-- https://github.com/christoomey/vim-tmux-navigator
--

return {
  'christoomey/vim-tmux-navigator',
  keys = {
    {
      '<C-h>',
      '<cmd>TmuxNavigateLeft<cr>',
      desc = 'which_key_ignore',
    },
    {
      '<C-l>',
      '<cmd>TmuxNavigateRight<cr>',
      desc = 'which_key_ignore',
    },
    {
      '<C-j>',
      '<cmd>TmuxNavigateDown<cr>',
      desc = 'which_key_ignore',
    },
    {
      '<C-k>',
      '<cmd>TmuxNavigateUp<cr>',
      desc = 'which_key_ignore',
    },
  },
}
