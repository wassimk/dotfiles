--
-- lua filetype
--

-- format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    require('conform').format()
  end,
  group = vim.api.nvim_create_augroup('WamAutocmdsLuaFormatting', {}),
})
