--
-- nvim-treesitter, nvim-treesitter-endwise, vim-matchup, nvim-treesitter/playground, nvim-ts-autotag
-- https://github.com/nvim-treesitter/nvim-treesitter
-- https://github.com/andymass/vim-matchup
-- https://github.com/RRethy/nvim-treesitter-endwise
-- https://github.com/nvim-treesitter/playground
-- https://github.com/windwp/nvim-ts-autotag
--

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
    'andymass/vim-matchup',
    'nvim-treesitter/playground',
    'windwp/nvim-ts-autotag',
  },
  config = {
    vim.api.nvim_set_hl(0, 'MatchWord', { italic = true }),
  },
}
