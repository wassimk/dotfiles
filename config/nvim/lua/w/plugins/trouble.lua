--
-- trouble.nvim
-- https://github.com/folke/trouble.nvim
--

return {
  'folke/trouble.nvim',
  cmd = { 'Trouble', 'TroubleToggle' },
  keys = {
    { '<leader>dr', '<cmd>TroubleToggle<cr>', mode = 'n', desc = 'DIAGNOSTICS: toggle trouble' },
  },
  opts = {
    padding = false,
  },
}
