--
-- tint.nvim
-- https://github.com/levouh/tint.nvim
--

return {
  'levouh/tint.nvim',
  config = {
    focus_change_events = {
      focus = { 'WinEnter', 'FocusGained' },
      unfocus = { 'WinLeave', 'FocusLost' },
    },
    highlight_ignore_patterns = { 'EndOfBuffer' },
  },
}
