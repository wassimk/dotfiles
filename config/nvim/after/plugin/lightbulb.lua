--
-- nvim-lightbulb
-- https://github.com/kosayoda/nvim-lightbulb
--

local has_lightbulb, lightbulb = pcall(require, 'nvim-lightbulb')

if not has_lightbulb then
  return
end

lightbulb.setup({
  ignore = { 'null_ls', 'null-ls' },
  sign = {
    enabled = true,
    priority = 20,
  },
  autocmd = {
    enabled = true,
    pattern = { '*' },
    events = { 'CursorHold', 'CursorHoldI' },
  },
})
