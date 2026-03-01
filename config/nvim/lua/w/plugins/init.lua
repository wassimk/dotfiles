return {
  -- many plugins use these, so not listed as dependencies on them
  { 'nvim-lua/plenary.nvim', lazy = true },

  { 'nvim-tree/nvim-web-devicons', lazy = true, opts = { default = true } },

  -- text objects / motions / vim
  { 'kana/vim-textobj-entire', dependencies = 'kana/vim-textobj-user' },
  { 'kana/vim-textobj-indent', dependencies = 'kana/vim-textobj-user' },
  { 'kana/vim-textobj-line', dependencies = 'kana/vim-textobj-user' },

  'tpope/vim-repeat',

  'tpope/vim-unimpaired',
}
