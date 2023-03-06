--
-- vim-tmux-navigator
-- https://github.com/christoomey/vim-tmux-navigator
--

vim.keymap.set({ 'n' }, '<C-h>', '<cmd>TmuxNavigateLeft<cr>')
vim.keymap.set({ 'n' }, '<C-l>', '<cmd>TmuxNavigateRight<cr>')
vim.keymap.set({ 'n' }, '<C-j>', '<cmd>TmuxNavigateDown<cr>')
vim.keymap.set({ 'n' }, '<C-k>', '<cmd>TmuxNavigateUp<cr>')
