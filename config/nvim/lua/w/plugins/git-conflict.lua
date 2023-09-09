--
-- git-conflict.nvim
-- https://github.com/akinsho/git-conflict.nvim
--

return {
  'akinsho/git-conflict.nvim',
  version = '*',
  config = function()
    require('git-conflict').setup({
      default_mappings = false,
      disable_diagnostics = true,
    })
  end,
}
