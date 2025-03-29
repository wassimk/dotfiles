--
-- Syntax Tree LSP
--

local default_config = require('lspconfig.configs.syntax_tree').default_config
default_config.root_dir = nil

local custom_config = {
  cmd = { 'bundle', 'exec', 'stree', 'lsp' },
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
}

return vim.tbl_deep_extend('force', default_config, custom_config)
