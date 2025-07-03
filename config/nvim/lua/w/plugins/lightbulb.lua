--
-- nvim-lightbulb
-- https://github.com/kosayoda/nvim-lightbulb
--

return {
  'kosayoda/nvim-lightbulb',
  event = 'CursorHold',
  opts = {
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
