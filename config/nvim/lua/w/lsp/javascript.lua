--
-- typesscript language server
--

-- this plugin calls lspconfig and sets up tsserver
require('typescript-tools').setup({
  debug = false,
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
  settings = {
    expose_as_code_action = {
      -- 'add_missing_imports',
      -- 'organize_imports',
      -- 'remove_unused',
      -- 'remove_unused_imports',
    },
  },
})
