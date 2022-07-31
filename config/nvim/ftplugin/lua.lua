--
-- lua filetype
--

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    -- HACK: neovim 0.8 changed formatting_seq_sync to format
    vim.lsp.buf.format()
  end,
  group = vim.api.nvim_create_augroup('WamAutocmdsLuaFormatting', {}),
})
