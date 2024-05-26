--
-- git-conflict.nvim
-- https://github.com/akinsho/git-conflict.nvim
--

return {
  'akinsho/git-conflict.nvim',
  event = 'BufRead',
  opts = {
    default_mappings = true,
    disable_diagnostics = true,
  },
}
