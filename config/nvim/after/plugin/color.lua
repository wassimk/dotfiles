require('onedark').setup({
  style = 'darker',
})

require('onedark').load()

vim.api.nvim_set_hl(0, 'MatchWord', { italic = true })
