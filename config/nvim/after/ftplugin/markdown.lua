--
-- markdown filetype
--

-- format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format()
  end,
  group = vim.api.nvim_create_augroup('WamAutocmdsLuaFormatting', {}),
})

vim.o.spell = true

pcall(function()
  require('wrapping').soft_wrap_mode()
end)
