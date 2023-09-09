--
-- todo-comments.nvim
-- https://github.com/folke/todo-comments.nvim
--

return {
  'folke/todo-comments.nvim',
  event = 'BufRead',
  config = function()
    require('todo-comments').setup({
      signs = false,
      sign_priority = 5, -- lower than gitsigns
    })
  end,
}
