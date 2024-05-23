--
-- go.nvim
-- https://github.com/ray-x/go.nvim
--

return {
  'ray-x/go.nvim',
  ft = { 'go' },
  build = ':lua require("go.install").update_all_sync()',
  config = function()
    require('go').setup({
      -- other setups ....
      lsp_cfg = {
        capabilities = require('w.lsp').capabilities(),
        on_attach = require('w.lsp').on_attach,
        -- other setups
      },
    })
  end,
}
