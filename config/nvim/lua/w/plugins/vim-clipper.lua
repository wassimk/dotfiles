--
-- vim-clipper
-- https://github.com/wincent/vim-clipper
--

return {
  'wincent/vim-clipper',
  version = '*',
  config = function()
    -- this autocmd group saves to system clipboard on every yank
    vim.api.nvim_del_augroup_by_name('Clipper')
  end,
}
