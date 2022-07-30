--
-- lua filetype
--

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.formatting_seq_sync()
  end,
  group = vim.api.nvim_create_augroup('WamAutocmdsLuaFormatting', {}),
})
