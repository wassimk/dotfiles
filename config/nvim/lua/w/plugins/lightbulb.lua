--
-- nvim-lightbulb
-- https://github.com/kosayoda/nvim-lightbulb
--

return {
  'kosayoda/nvim-lightbulb',
  opts = {
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
  },
}
