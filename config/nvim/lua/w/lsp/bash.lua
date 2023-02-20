--
-- bash language server
--

require('lspconfig').bashls.setup({
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
