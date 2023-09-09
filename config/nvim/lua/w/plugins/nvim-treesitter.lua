--
-- nvim-treesitter, nvim-treesitter-endwise, vim-matchup, nvim-ts-autotag
-- https://github.com/nvim-treesitter/nvim-treesitter
-- https://github.com/andymass/vim-matchup
-- https://github.com/RRethy/nvim-treesitter-endwise
-- https://github.com/windwp/nvim-ts-autotag
--

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
    'andymass/vim-matchup',
    'windwp/nvim-ts-autotag',
  },
  config = function()
    vim.api.nvim_set_hl(0, 'MatchWord', { italic = true })
  end,
}
