--
-- git-conflict.nvim
-- https://github.com/akinsho/git-conflict.nvim
--

return {
  'akinsho/git-conflict.nvim',
  version = '*',
  event = 'BufRead',
  opts = {
    default_mappings = true,
    -- can't enable in neovim nightly
    -- https://github.com/akinsho/git-conflict.nvim/issues/119
    disable_diagnostics = false,
  },
}
