--
-- vim-tmux-navigator
-- https://github.com/christoomey/vim-tmux-navigator
--

return {
  'christoomey/vim-tmux-navigator',
  config = function()
    vim.g.tmux_navigator_no_mappings = 1

    vim.keymap.set({ 'n' }, '<C-h>', '<cmd>TmuxNavigateLeft<cr>')
    vim.keymap.set({ 'n' }, '<C-l>', '<cmd>TmuxNavigateRight<cr>')
    vim.keymap.set({ 'n' }, '<C-j>', '<cmd>TmuxNavigateDown<cr>')
    vim.keymap.set({ 'n' }, '<C-k>', '<cmd>TmuxNavigateUp<cr>')
  end,
}
