--
-- nvim-treesitter (main branch)
-- https://github.com/nvim-treesitter/nvim-treesitter/tree/main
--
-- The main branch is a minimal rewrite: parser/query installer that
-- delegates highlight/fold to built-in Neovim. Parsers live under
-- stdpath('data')/site/parser. Configure via require('w.treesitter').
--

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
}
