--
-- vim-gutentags
-- https://github.com/ludovicchabant/vim-gutentags
--

return {
  'ludovicchabant/vim-gutentags',
  config = function()
    vim.g.gutentags_ctags_executable_ruby = vim.fn.stdpath('data') .. '/mason/bin/ripper-tags'
    vim.g.gutentags_ctags_extra_args = { '--ignore-unsupported-options', '--recursive' }
  end,
}
