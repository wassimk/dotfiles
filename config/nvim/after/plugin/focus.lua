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
  excluded_filetypes = { 'harpoon', 'telescoperesults', 'telescopeprompt', 'tsplayground' },
  excluded_buftypes = { 'nofile', 'prompt', 'popup', 'trouble', 'help' },
})
