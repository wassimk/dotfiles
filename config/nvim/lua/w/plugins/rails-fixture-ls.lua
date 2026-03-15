--
-- rails-fixture-ls.nvim
-- https://github.com/wassimk/rails-fixture-ls.nvim
--

return {
  'wassimk/rails-fixture-ls.nvim',
  dev = true,
  ft = 'ruby',
  config = function()
    vim.lsp.enable('rails_fixture_ls')
  end,
}
