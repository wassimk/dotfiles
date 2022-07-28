local wamGrp = vim.api.nvim_create_augroup('WamAutocmdsLuaFormatting', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  command = 'lua require("stylua-nvim").format_file()',
  group = wamGrp,
})
