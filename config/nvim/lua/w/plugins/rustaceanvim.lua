--
-- rustaceanvim
-- https://github.com/mrcjkb/rustaceanvim
--

vim.g.rustaceanvim = {
  server = {
    capabilities = require('w.lsp').capabilities(),
  },
}

return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false, -- This plugin is already lazy
}
