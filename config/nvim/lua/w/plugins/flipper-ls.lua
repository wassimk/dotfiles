--
-- flipper-ls.nvim
-- https://github.com/wassimk/flipper-ls.nvim
--

return {
  'wassimk/flipper-ls.nvim',
  dev = true,
  ft = { 'ruby', 'eruby', 'javascript', 'typescript', 'typescriptreact', 'javascriptreact' },
  config = function()
    vim.lsp.enable('flipper_ls')
  end,
}
