--
-- lua filetype
--

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    require('stylua-nvim').format_file()
  end,
  group = vim.api.nvim_create_augroup('WamAutocmdsLuaFormatting', {}),
})
