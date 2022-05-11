local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Code / Git
  use 'dense-analysis/ale'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-eunuch'
  use 'windwp/nvim-autopairs'
  use 'janko-m/vim-test'
  use 'williamboman/nvim-lsp-installer'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-path'
  use 'f3fora/cmp-spell'
  use 'dcampos/nvim-snippy'
  use 'dcampos/cmp-snippy'
  use 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'

  -- JavaScript
  use 'pangloss/vim-javascript'
  use 'mxw/vim-jsx'
  use 'leafgarland/typescript-vim'
  use 'peitalin/vim-jsx-typescript'
  use 'maxmellon/vim-jsx-pretty'

  -- Ruby / Rails
  use 'nelstrom/vim-textobj-rubyblock'
  use 'vim-ruby/vim-ruby'
  use 'tpope/vim-rails'

  -- Vim Text Objects and Motions
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'wellle/targets.vim'
  use 'kana/vim-textobj-user'
  use 'kana/vim-textobj-line'
  use 'kana/vim-textobj-entire'
  use 'kana/vim-textobj-indent'
  use 'christoomey/vim-sort-motion'
  use 'junegunn/vim-easy-align'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-abolish'

  -- Files And Search
  use 'ctrlpvim/ctrlp.vim'
  use 'JazzCore/ctrlp-cmatcher'
  use { 'scrooloose/nerdtree', cmd = { 'NERDTreeToggle' } }
  use 'Xuyuanp/nerdtree-git-plugin'
  use 'wincent/loupe'
  use 'wincent/ferret'
  use 'wincent/scalpel'
  -- use { "junegunn/fzf", run = { ":fzf#install()" } }
  use 'junegunn/fzf.vim'

  -- Pretty much automatic
  use 'wincent/vim-clipper'
  use 'Yggdroot/indentLine'
  use 'tpope/vim-repeat'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'editorconfig/editorconfig-vim'

  -- Theme / Status Line / Tmux / Terminal / Vim
  use 'joshdick/onedark.vim'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'edkolev/tmuxline.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'wincent/terminus'
  use 'milkypostman/vim-togglelist'


  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
