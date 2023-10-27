--
-- trouble.nvim
-- https://github.com/folke/trouble.nvim
--

return {
  'folke/trouble.nvim',
  cmd = { 'Trouble', 'TroubleToggle' },
  keys = {
    { '<leader>tr', '<cmd>TroubleToggle<cr>', mode = 'n', desc = 'TROUBLE: toggle window' },
  },
  opts = {
    padding = false,
  },
}
