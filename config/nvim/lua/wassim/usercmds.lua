local api = vim.api

api.nvim_create_user_command('Lg', 'FloatermNew lazygit', { desc = 'launch lazygit with floaterm' })

api.nvim_create_user_command('VimConflicted', function()
  -- add conflicted version name to statusline
  vim.wo.statusline = vim.wo.statusline .. '%{ConflictedVersion()}'

  -- resolve and move to next conflicted file
  vim.keymap.set('n', ']m', 'GitNextConflict', { noremap = true, silent = true })
end, { desc = 'vim-conflicted calls when entering conflicted state' })
