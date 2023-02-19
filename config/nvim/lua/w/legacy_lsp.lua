----
-- lsp
----
local capabilities = require('w.lsp').capabilities()
local on_attach = require('w.lsp').on_attach

-- vimscript
require('lspconfig').vimls.setup({
  init_options = { isNeovim = true },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- html
require('lspconfig').html.setup({ capabilities = capabilities, on_attach = on_attach })

-- css
require('lspconfig').cssls.setup({ capabilities = capabilities, on_attach = on_attach })

-- javascript / typescript
-- this plugin calls lspconfig and sets up tsserver
require('typescript').setup({
  disable_commands = false, -- :Typescript* commands
  debug = false,
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
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

----
-- rust
----
-- use library from vscode CodeLLDB extension
local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.7.4/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

require('dap').adapters.lldb = {
  type = 'executable',
  attach = { pidProperty = 'pid', pidSelect = 'ask' },
  command = 'lldb-vscode',
  name = 'lldb',
  env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = 'YES' },
}

local opts = {
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
  },
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
  },
}

-- this plugin calls lspconfig and sets up rust-analyzer and nvim-dap
require('rust-tools').setup(opts)
