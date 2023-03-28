--
-- remark language server
--

if require('w.utils').config_exists('.remarkrc.json') then
  require('lspconfig').remark_ls.setup({
    capabilities = require('w.lsp').capabilities(),
    on_attach = require('w.lsp').on_attach,
  })
end
