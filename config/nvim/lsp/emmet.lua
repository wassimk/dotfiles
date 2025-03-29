--
-- emmet language server
-- https://github.com/olrtg/emmet-language-server
--

local default_config = require('lspconfig.configs.emmet_language_server').default_config
default_config.root_dir = nil

local custom_config = {
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
}

return vim.tbl_deep_extend('force', default_config, custom_config)
