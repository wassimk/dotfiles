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
      enabled = false,
      priority = 20,
    },
    virtual_text = {
      enabled = true,
    },
    autocmd = {
      enabled = true,
    },
  },
}
