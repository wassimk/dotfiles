--
-- vim language server
--

require('lspconfig').vimls.setup({
  init_options = { isNeovim = true },
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
