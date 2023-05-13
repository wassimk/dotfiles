--
-- rust dap & language server
--

local mason_registry = require('mason-registry')
local codelldb = mason_registry.get_package('codelldb')
local extension_path = codelldb:get_install_path() .. '/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

local opts = {
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
  },
  server = {
    capabilities = require('w.lsp').capabilities(),
    on_attach = require('w.lsp').on_attach,
  },
}

-- this plugin calls lspconfig and sets up rust-analyzer and nvim-dap
require('rust-tools').setup(opts)
