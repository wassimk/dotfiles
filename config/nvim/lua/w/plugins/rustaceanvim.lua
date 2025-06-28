--
-- rustaceanvim
-- https://github.com/mrcjkb/rustaceanvim
--

vim.g.rustaceanvim = {
  server = {
    capabilities = require('w.lsp').capabilities(),
    on_attach = require('w.lsp').on_attach,
  },
}

return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false, -- This plugin is already lazy
}
