local wamGrp = vim.api.nvim_create_augroup('WamAutocmdsRubyFormatting', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  command = 'silent! PrettierAsync',
  group = wamGrp,
})
