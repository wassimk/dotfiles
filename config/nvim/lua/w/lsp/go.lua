--
-- go language server
-- https://github.com/golang/tools/tree/master/gopls
--

require('lspconfig').gopls.setup({
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      formatting = {
        gofumpt = true,
      },
      -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
      analyses = {
        unusedparams = true,
        useany = true,
        shadow = true,
      },
    },
  },
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
