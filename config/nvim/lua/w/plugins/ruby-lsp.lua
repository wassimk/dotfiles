--
-- ruby-lsp.nvim
-- https://github.com/wassimk/ruby-lsp.nvim
--

return {
  'wassimk/ruby-lsp.nvim',
  dev = true,
  ft = 'ruby',
  opts = {
    executor = 'toggleterm',
    toggleterm = {
      direction = 'horizontal',
    },
  },
}
