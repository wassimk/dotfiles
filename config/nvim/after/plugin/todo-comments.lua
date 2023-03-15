--
-- todo-comments.nvim
-- https://github.com/folke/todo-comments.nvim
--

local has_todo_comments, todo_comments = pcall(require, 'todo-comments')

if not has_todo_comments then
  return
end

todo_comments.setup({
  signs = false,
  sign_priority = 5, -- lower than gitsigns
})
