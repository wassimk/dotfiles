--
-- focus.nvim
-- https://github.com/beauwilliams/focus.nvim
--

return {
  'nvim-focus/focus.nvim',
  version = '*',
  opts = {
    width = 120,
    quickfixheight = 10,
    excluded_filetypes = { 'qf', 'harpoon', 'tsplayground', 'Trouble', 'help', 'toggleterm' },
    excluded_buftypes = { 'quickfix', 'nofile', 'prompt', 'popup', 'quickfix', 'TelescopePrompt' },
  },
}
