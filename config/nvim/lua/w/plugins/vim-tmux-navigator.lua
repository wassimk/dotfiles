--
-- vim-tmux-navigator
-- https://github.com/christoomey/vim-tmux-navigator
--

return {
  'christoomey/vim-tmux-navigator',
  config = function()
    vim.keymap.set({ 'n' }, '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { desc = 'which_key_ignore' })
    vim.keymap.set({ 'n' }, '<C-l>', '<cmd>TmuxNavigateRight<cr>', { desc = 'which_key_ignore' })
    vim.keymap.set({ 'n' }, '<C-j>', '<cmd>TmuxNavigateDown<cr>', { desc = 'which_key_ignore' })
    vim.keymap.set({ 'n' }, '<C-k>', '<cmd>TmuxNavigateUp<cr>', { desc = 'which_key_ignore' })
  end,
}
