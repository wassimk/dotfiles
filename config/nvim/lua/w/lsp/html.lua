--
-- html language server
--

require('lspconfig').html.setup({
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
