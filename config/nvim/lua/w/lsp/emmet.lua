--
-- emmet language server
-- https://github.com/olrtg/emmet-language-server
--

require('lspconfig').emmet_language_server.setup({
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
