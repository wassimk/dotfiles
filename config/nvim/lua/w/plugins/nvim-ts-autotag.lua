--
-- nvim-ts-autotag
-- https://github.com/windwp/nvim-ts-autotag
--
-- Auto-close/rename HTML/JSX tags. Needs the html/tsx treesitter parser on
-- the runtimepath (installed via w.treesitter).
--

return {
  'windwp/nvim-ts-autotag',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {},
}
