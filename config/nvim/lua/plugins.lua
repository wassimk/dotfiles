local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Code / Git
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-eunuch'
  use 'windwp/nvim-autopairs'
  use 'github/copilot.vim'
  use 'wincent/vcs-jump'

  use { 'janko-m/vim-test',
    requires = {
      'tpope/vim-dispatch'
    }
  }

  use { 'neovim/nvim-lspconfig',
    requires = {
      'williamboman/nvim-lsp-installer',
      'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'
    }
  }

  use { 'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'f3fora/cmp-spell',
    }
  }

  use { 'dcampos/nvim-snippy',
    requires = {
      'dcampos/cmp-snippy'
    }
  }

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
  use 'numToStr/Comment.nvim'
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
  use 'prettier/vim-prettier'

  -- Files And Search
  use 'wincent/loupe'
  use 'wincent/ferret'
  use 'wincent/scalpel'
  use { 'junegunn/fzf', run = './install --bin' }
  use 'junegunn/fzf.vim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'kyazdani42/nvim-web-devicons'
    }
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
  }

  -- Pretty much automatic
  use 'wincent/vim-clipper'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sensible'
  use 'editorconfig/editorconfig-vim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Theme / Status Line / Tmux / Terminal / Vim
  use 'joshdick/onedark.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'wincent/terminus'
  use 'milkypostman/vim-togglelist'
  use 'nvim-lualine/lualine.nvim'
  use 'akinsho/bufferline.nvim'

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
