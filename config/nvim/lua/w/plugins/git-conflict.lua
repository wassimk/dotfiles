--
-- git-conflict.nvim
-- https://github.com/akinsho/git-conflict.nvim
--

return {
  'akinsho/git-conflict.nvim',
  version = '*',
  event = 'BufRead',
  opts = {
    default_mappings = false,
    disable_diagnostics = true,
  },
}
