--
-- vim-tmux-navigator
-- https://github.com/christoomey/vim-tmux-navigator
--
vim.g.tmux_navigator_no_mappings = 1

vim.keymap.set({ 'n' }, '<C-h>', '<cmd>TmuxNavigateLeft<cr>')
vim.keymap.set({ 'n' }, '<C-l>', '<cmd>TmuxNavigateRight<cr>')
vim.keymap.set({ 'n' }, '<C-j>', '<cmd>TmuxNavigateDown<cr>')
vim.keymap.set({ 'n' }, '<C-k>', '<cmd>TmuxNavigateUp<cr>')

-- noremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
-- noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
-- noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
-- noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
-- noremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>
