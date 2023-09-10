--
-- javascript language servers
--

local capabilities = require('w.lsp').capabilities()
local on_attach = require('w.lsp').on_attach

-- javascript / typescript
-- this plugin calls lspconfig and sets up tsserver

local mason_registry = require('mason-registry')
local tsserver_path = mason_registry.get_package('typescript-language-server'):get_install_path()

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

    tsserver_path = tsserver_path .. '/node_modules/typescript/lib/tsserver.js',
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
