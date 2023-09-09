--
-- vim-ruby, vim-rails
-- https://github.com/vim-ruby/vim-ruby
-- https://github.com/tpope/vim-rails
--

return {
  'vim-ruby/vim-ruby',
  -- this doesn't work with lazy.nvim plugin structure
  -- ft = 'ruby',
  dependencies = {
    'tpope/vim-rails',
  },
  config = function()
    vim.keymap.set({ 'n', 'x' }, '<leader>a', '<cmd>A<cr>', { desc = 'VIM-RAILS: alternate file' })
  end,
}
