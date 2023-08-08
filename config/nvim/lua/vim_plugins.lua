local M = {}

function M.setup()
  -- remap leader and local leader to <Space>
  -- done this early because some vim plugins need it so also still done in
  -- keymap area because this should go away when we no longer using any vim
  -- specific plugins
  vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {})
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  --vim-tmux-navigator
  vim.g.tmux_navigator_no_mappings = 1

  --vim-gutentags
  vim.g.gutentags_ctags_executable_ruby = vim.fn.stdpath('data') .. '/mason/bin/ripper-tags'
  vim.g.gutentags_ctags_extra_args = { '--ignore-unsupported-options', '--recursive' }
end

return M
