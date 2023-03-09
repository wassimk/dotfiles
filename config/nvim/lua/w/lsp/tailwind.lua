--
-- tailwind language server
--

require('lspconfig').tailwindcss.setup({
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
