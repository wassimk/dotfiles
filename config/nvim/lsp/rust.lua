--
-- rust language server
--

-- setup handled by the mrcjkb/rustaceanvim plugin
vim.g.rustaceanvim = function()
  return {
    server = {
      on_attach = require('w.lsp').on_attach,
    },
  }
end
