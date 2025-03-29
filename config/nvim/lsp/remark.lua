--
-- remark language server
--

local default_config = require('lspconfig.configs.remark_ls').default_config
default_config.root_dir = nil

local custom_config = {
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
}

return vim.tbl_deep_extend('force', default_config, custom_config)
