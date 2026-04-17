--
-- vim-matchup
-- https://github.com/andymass/vim-matchup
--

return {
  'andymass/vim-matchup',
  event = { 'BufReadPre', 'BufNewFile' },
  init = function()
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
  end,
  config = function()
    vim.api.nvim_set_hl(0, 'MatchWord', { italic = true })
  end,
}
