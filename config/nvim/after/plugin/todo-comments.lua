--
-- todo-comments.nvim
-- https://github.com/folke/todo-comments.nvim
--

local has_todo_comments, todo_comments = pcall(require, 'todo-comments')

if has_todo_comments then
  todo_comments.setup({
    sign_priority = 5, -- lower than gitsigns
  })
end
