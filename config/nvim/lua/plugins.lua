local M = {}

function M.setup()
  -- used for first time install check
  local packer_bootstrap = false

  -- packer.nvim use popup window instead of a split
  local conf = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'rounded' })
      end,
    },
  }

  -- install packer.nvim if not installed
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap =
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })

      -- vim.cmd([[packadd packer.nvim]])
    end

    -- install and sync plugins on file change
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = { 'plugins.lua' },
      command = 'source <afile> | PackerSync',
      group = vim.api.nvim_create_augroup('WamPackerSync', {}),
      desc = 'Reload the plugins.lua file and run PackerSync on save',
    })
  end

  local function plugins(use)
    use('wbthomason/packer.nvim')

    use('lewis6991/impatient.nvim')
    use('dstein64/vim-startuptime')

    -- Code / Git
    use({
      'tpope/vim-fugitive',
      requires = {
        'tpope/vim-rhubarb',
        'tpope/vim-dispatch', -- used for Gbrowse command
      },
    })

    use('christoomey/vim-conflicted')
    use('tpope/vim-eunuch')
    use('github/copilot.vim')
    use('wincent/vcs-jump')
    use('lewis6991/gitsigns.nvim')
    use('folke/todo-comments.nvim')
    use('folke/trouble.nvim')

    use('hkupty/iron.nvim')

    use({ 'janko-m/vim-test', requires = {
      'voldikss/vim-floaterm',
    } })

    use('williamboman/mason.nvim')
    use('WhoIsSethDaniel/mason-tool-installer.nvim')

    use({
      'wassimk/nvim-lspconfig',
      branch = 'add-syntax_tree',
      requires = {
        'williamboman/mason-lspconfig.nvim',
        'jose-elias-alvarez/typescript.nvim',
      },
    })

    use('j-hui/fidget.nvim')
    use('jose-elias-alvarez/null-ls.nvim')
    use('ThePrimeagen/refactoring.nvim')

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
        'ray-x/cmp-treesitter',
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

    -- Ruby / Rails
    use('vim-ruby/vim-ruby')
    use('tpope/vim-rails')

    -- Vim Text Objects and Motions
    use('numToStr/Comment.nvim')
    use('kylechui/nvim-surround')
    use('christoomey/vim-sort-motion')
    use('junegunn/vim-easy-align')
    use('tpope/vim-unimpaired')
    use('tpope/vim-abolish')

    use('kana/vim-textobj-user')
    use('kana/vim-textobj-line')
    use('kana/vim-textobj-entire')
    use('kana/vim-textobj-indent')

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

    use('yssl/QFEnter')

    -- Pretty much automatic
    use('beauwilliams/focus.nvim')
    use('wincent/vim-clipper')
    use('lukas-reineke/indent-blankline.nvim')
    use('tpope/vim-repeat')
    use('tpope/vim-sensible')
    use('editorconfig/editorconfig-vim')
    use('ludovicchabant/vim-gutentags')
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        'nvim-treesitter/playground',
        'windwp/nvim-ts-autotag',
        'RRethy/nvim-treesitter-endwise',
        'windwp/nvim-autopairs',
        'andymass/vim-matchup',
      },
    })

    -- Theme / Status Line / Tmux / Terminal / Vim
    use('navarasu/onedark.nvim')
    use('christoomey/vim-tmux-navigator')
    use('wincent/terminus')
    use('milkypostman/vim-togglelist')
    use('nvim-lualine/lualine.nvim')
    use('akinsho/bufferline.nvim')

    if packer_bootstrap then
      vim.notify('packer.nvim installed with plugins, restart neovim!')
      require('packer').sync()
    end
  end

  -- first install and sync
  packer_init()

  -- load packer.nvim and plugins
  local packer = require('packer')
  packer.init(conf)
  packer.startup(plugins)
end

return M
