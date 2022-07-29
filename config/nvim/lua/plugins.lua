local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap =
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

-- Don't crash if packer was just installed
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { 'plugins.lua' },
  command = 'source <afile> | PackerSync',
  group = vim.api.nvim_create_augroup('WamPackerSync', { clear = true }),
  desc = 'Reload the plugins.lua file and run PackerSync on save',
})

-- Use popup window instead of a split
packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
  },
})

return packer.startup(function(use)
  use('wbthomason/packer.nvim')

  -- Code / Git
  use('tpope/vim-fugitive')
  use('tpope/vim-rhubarb')
  use('christoomey/vim-conflicted')
  use('tpope/vim-eunuch')
  use('windwp/nvim-autopairs')
  use('RRethy/nvim-treesitter-endwise')
  use('windwp/nvim-ts-autotag')
  use('github/copilot.vim')
  use('wincent/vcs-jump')
  use('lewis6991/gitsigns.nvim')
  use({ 'ckipp01/stylua-nvim', run = 'cargo install stylua' })
  use('folke/todo-comments.nvim')

  use({ 'janko-m/vim-test', requires = {
    'tpope/vim-dispatch',
  } })

  use('williamboman/mason.nvim')
  use({
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
    },
  })

  use('nvim-lua/lsp-status.nvim')

  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'petertriho/cmp-git',
      'hrsh7th/cmp-path',
      'f3fora/cmp-spell',
      'onsails/lspkind.nvim',
    },
  })

  use('~/personal/neovim/cmp-rails-fixture-types')
  use('~/personal/neovim/cmp-rails-fixture-names')
  use('~/personal/neovim/cmp-feature-flipper')

  -- Snippets with completion
  use({ 'L3MON4D3/LuaSnip', requires = {
    'saadparwaiz1/cmp_luasnip',
  } })

  -- JavaScript
  use('pangloss/vim-javascript')
  use('mxw/vim-jsx')
  use('leafgarland/typescript-vim')
  use('peitalin/vim-jsx-typescript')
  use('maxmellon/vim-jsx-pretty')

  -- Ruby / Rails
  use('nelstrom/vim-textobj-rubyblock')
  use('vim-ruby/vim-ruby')
  use('tpope/vim-rails')

  -- Vim Text Objects and Motions
  use('numToStr/Comment.nvim')
  use('kylechui/nvim-surround')
  use('wellle/targets.vim')
  use('kana/vim-textobj-user')
  use('kana/vim-textobj-line')
  use('kana/vim-textobj-entire')
  use('kana/vim-textobj-indent')
  use('christoomey/vim-sort-motion')
  use('junegunn/vim-easy-align')
  use('tpope/vim-unimpaired')
  use('tpope/vim-abolish')
  -- use 'prettier/vim-prettier'
  use({ 'wassimk/vim-prettier', branch = 'tweaks' })

  -- Files And Search
  use('wincent/loupe')
  use('wincent/ferret')
  use('wincent/scalpel')

  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-ui-select.nvim',
    },
  })

  use({
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
  })

  -- Pretty much automatic
  use('wincent/vim-clipper')
  use('lukas-reineke/indent-blankline.nvim')
  use('tpope/vim-repeat')
  use('tpope/vim-sensible')
  use('editorconfig/editorconfig-vim')
  use('ludovicchabant/vim-gutentags')
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
  use('andymass/vim-matchup')

  -- Theme / Status Line / Tmux / Terminal / Vim
  use('navarasu/onedark.nvim')
  use('christoomey/vim-tmux-navigator')
  use('wincent/terminus')
  use('milkypostman/vim-togglelist')
  use('nvim-lualine/lualine.nvim')
  use('b0o/incline.nvim')
  use('akinsho/bufferline.nvim')

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
