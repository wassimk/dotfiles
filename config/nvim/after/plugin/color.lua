require('onedark').setup({
  style = 'darker',
})

require('onedark').load()

-- used by vim-matchup plugin
vim.api.nvim_set_hl(0, 'MatchWord', { italic = true })

-- diagnostic icons in gutter
local signs = {
  Error = ' ',
  Warn = ' ',
  Info = ' ',
  Hint = ' ',
}

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type

  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end
