--
-- yaml language server
--

require('lspconfig').yamlls.setup({
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
