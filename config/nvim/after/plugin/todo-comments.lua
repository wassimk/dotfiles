--
-- todo-comments.nvim
-- https://github.com/folke/todo-comments.nvim
--

-- NOTE: workaround until issue is fixed upstream
-- https://github.com/folke/todo-comments.nvim/issues/97
local hl = require('todo-comments.highlight')
local highlight_win = hl.highlight_win
hl.highlight_win = function(win, force)
  pcall(highlight_win, win, force)
end

require('todo-comments').setup({
  sign_priority = 5, -- lower than gitsigns
})
