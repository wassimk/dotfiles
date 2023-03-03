--
-- focus.nvim
-- https://github.com/beauwilliams/focus.nvim
--

local has_focus, focus = pcall(require, 'focus')

if not has_focus then
  return
end

focus.setup({
  width = 120,
  quickfixheight = 10,
  excluded_filetypes = { 'qf', 'harpoon', 'tsplayground', 'Trouble', 'help', 'toggleterm' },
  excluded_buftypes = { 'quickfix', 'nofile', 'prompt', 'popup', 'quickfix', 'TelescopePrompt' },
})
