return {
  -- profile neovim
  'lewis6991/impatient.nvim',

  { 'dstein64/vim-startuptime', cmd = 'StartupTime' },

  -- many plugins use these, so not listed as dependencies on them
  { 'nvim-lua/plenary.nvim', lazy = true },

  { 'kyazdani42/nvim-web-devicons', lazy = true, config = { default = true } },

  -- text objects / motions / vim
  { 'kana/vim-textobj-entire', dependencies = 'kana/vim-textobj-user' },
  { 'kana/vim-textobj-indent', dependencies = 'kana/vim-textobj-user' },
  { 'kana/vim-textobj-line', dependencies = 'kana/vim-textobj-user' },

  'tpope/vim-repeat',

  'junegunn/vim-easy-align',

  'tpope/vim-unimpaired',
}
