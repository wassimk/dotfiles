--
-- todo-comments.nvim
-- https://github.com/folke/todo-comments.nvim
--

return {
  'folke/todo-comments.nvim',
  event = 'BufRead',
  cmd = { 'TodoLocList', 'TodoQuickFix', 'TodoSnacks' },
  opts = {
    signs = false,
    sign_priority = 5, -- lower than gitsigns
  },
  config = function(_, opts)
    require('todo-comments').setup(opts)

    vim.api.nvim_create_user_command('TodoSnacks', function()
      require('snacks').picker.todo_comments()
    end, { desc = 'Find todo comments with Snacks picker' })
  end,
}
