--
-- tint.nvim
-- https://github.com/levouh/tint.nvim
--

return {
  'levouh/tint.nvim',
  opts = {
    focus_change_events = {
      focus = { 'WinEnter', 'FocusGained' },
      unfocus = { 'WinLeave', 'FocusLost' },
    },
    highlight_ignore_patterns = { 'EndOfBuffer' },
  },
}
