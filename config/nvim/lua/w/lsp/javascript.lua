--
-- javascript language servers
--

local capabilities = require('w.lsp').capabilities()
local on_attach = require('w.lsp').on_attach

-- javascript / typescript
-- this plugin calls lspconfig and sets up tsserver
require('typescript-tools').setup({
  debug = false,
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    expose_as_code_action = {
      -- 'add_missing_imports',
      -- 'organize_imports',
      -- 'remove_unused',
      -- 'remove_unused_imports',
    },
  },
})

-- eslint
require('lspconfig').eslint.setup({
  settings = {
    validate = 'on',
    codeAction = {
      disableRuleComment = {
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
})
