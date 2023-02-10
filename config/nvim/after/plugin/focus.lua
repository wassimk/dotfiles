--
-- focus.nvim
-- https://github.com/beauwilliams/focus.nvim
--

local has_focus, focus = pcall(require, 'focus')

if has_focus then
  focus.setup({
    width = 120,
    excluded_buftypes = { 'nofile', 'prompt', 'popup', 'quickfix' },
  })
end
