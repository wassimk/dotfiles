--
-- go.nvim
-- https://github.com/ray-x/go.nvim
--

return {
  'ray-x/go.nvim',
  ft = { 'go' },
  -- install missing go tools in the background; update_all_sync rebuilds
  -- every tool from source and freezes neovim for minutes on each update
  build = ':lua require("go.install").install_all()',
  config = function()
    require('go').setup({
      lsp_cfg = true,
    })
  end,
}
