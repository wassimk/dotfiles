--
-- json filetype
--

require('lspconfig').jsonls.setup({
  init_options = {
    provideFormatter = true,
  },
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
