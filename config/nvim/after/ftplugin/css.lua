--
-- css filetype
--

require('lspconfig').cssls.setup({
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
