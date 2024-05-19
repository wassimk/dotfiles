--
-- go.nvim
-- https://github.com/ray-x/go.nvim
--

-- w.lsp.go package configures/starts the lsp server
return {
  'ray-x/go.nvim',
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()',
  config = function()
    require('go').setup()
  end,
}
