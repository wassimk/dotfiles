local wamGrp = vim.api.nvim_create_augroup('WamAutocmdsJavaScriptFormatting', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  command = 'silent! EslintFixAll',
  group = wamGrp,
})
