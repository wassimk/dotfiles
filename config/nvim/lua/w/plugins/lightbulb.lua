--
-- nvim-lightbulb
-- https://github.com/kosayoda/nvim-lightbulb
--

return {
  'kosayoda/nvim-lightbulb',
  config = function()
    require('nvim-lightbulb').setup({
      ignore = {
        clients = { 'null_ls', 'null-ls' },
      },
      sign = {
        enabled = true,
        priority = 20,
      },
      autocmd = {
        enabled = true,
      },
    })
  end,
}
