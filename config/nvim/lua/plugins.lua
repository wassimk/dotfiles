local M = {}

function M.setup()
  -- used for first time install check
  local packer_bootstrap = false

  -- packer.nvim config options for init
  local conf = {
    profile = {
      enable = true,
      threshold = 0, -- load time before included in reporting
    },
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'rounded' })
      end,
    },
    max_jobs = 20, -- prevent stalling on sync
  }

  -- install packer.nvim, if not installed
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap =
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    end

    -- re-compile plugins on file change
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = { 'plugins.lua' },
      command = 'source <afile> | PackerCompile',
      group = vim.api.nvim_create_augroup('WamPackerCompile', {}),
      desc = 'Reload the plugins.lua file and run PackerCompile on save',
    })
  end

  local function plugins(use)
    use('wbthomason/packer.nvim')

    -- profile neovim
    use('lewis6991/impatient.nvim')
    use('dstein64/vim-startuptime')

    -- many plugins use these, so not listed as required on them
    use({ 'nvim-lua/plenary.nvim', module = 'plenary' })

    use({
      'kyazdani42/nvim-web-devicons',
      module = 'nvim-web-devicons',
      config = require('lazy.nvim-web-devicons').setup(),
    })

    -- startup screen
    use('goolord/alpha-nvim')

    -- git
    use({
      'tpope/vim-fugitive',
      cmd = { 'GBrowse', 'Gdiff' },
      requires = {
        { 'tpope/vim-rhubarb', after = 'vim-fugitive' },
        { 'tpope/vim-dispatch', after = 'vim-rhubarb' },
      },
    })

    use({ 'wincent/vcs-jump', cmd = 'VcsJump' })
    use('lewis6991/gitsigns.nvim')
    use({
      'akinsho/git-conflict.nvim',
      tag = '*',
      config = function()
        require('git-conflict').setup()
      end,
    })

    -- repl
    use({
      'hkupty/iron.nvim',
      module = 'iron.core',
      config = function()
        require('lazy.iron').setup()
      end,
    })

    -- testing
    use({
      'janko-m/vim-test',
      cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
      config = function()
        require('lazy.vim-test').setup()
      end,
    })

    use({
      'voldikss/vim-floaterm',
      cmd = 'FloatermNew',
      config = function()
        require('lazy.vim-floaterm').setup()
      end,
    })

    -- lsp / copilot / diagnostics
    use('folke/todo-comments.nvim')

    use({
      cmd = 'Trouble',
      'folke/trouble.nvim',
      config = function()
        require('trouble').setup()
      end,
    })

    use('williamboman/mason.nvim')
    use('WhoIsSethDaniel/mason-tool-installer.nvim')

    use({
      'neovim/nvim-lspconfig',
      requires = {
        'williamboman/mason-lspconfig.nvim',
        'jose-elias-alvarez/typescript.nvim',
        'folke/lua-dev.nvim',
      },
    })

    use('j-hui/fidget.nvim')
    use('jose-elias-alvarez/null-ls.nvim')
    use('github/copilot.vim')

    use({
      'ThePrimeagen/refactoring.nvim',
      module = 'refactoring',
      config = function()
        require('refactoring').setup()
      end,
    })

    -- completion / snippets
    use({
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-nvim-lsp',
        'petertriho/cmp-git',
        'hrsh7th/cmp-path',
        'f3fora/cmp-spell',
        'ray-x/cmp-treesitter',
        'onsails/lspkind.nvim',
        { '~/personal/neovim/cmp-rails-fixture-types', ft = 'ruby' },
        { '~/personal/neovim/cmp-rails-fixture-names', ft = 'ruby' },
        { '~/personal/neovim/cmp-feature-flipper', ft = 'ruby' },
      },
    })

    use({
      'L3MON4D3/LuaSnip',
      requires = 'saadparwaiz1/cmp_luasnip',
    })

    -- ruby / rails
    use({
      'vim-ruby/vim-ruby',
      ft = 'ruby',
      requires = {
        { 'tpope/vim-rails', after = 'vim-ruby' },
      },
    })

    -- files and search
    use('wincent/loupe')
    use('wincent/ferret')
    use({ 'wincent/scalpel', keys = '<Leader>e' })

    use({
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      tag = '*',
      requires = {
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        'nvim-telescope/telescope-ui-select.nvim',
      },
      config = function()
        require('lazy.telescope').setup()
      end,
    })

    use({
      'kyazdani42/nvim-tree.lua',
      cmd = 'NvimTreeToggle',
      config = function()
        require('lazy.nvim-tree').setup()
      end,
    })

    -- text objects / motions
    use({
      'numToStr/Comment.nvim',
      keys = { 'gc', 'gcc', 'gbc' },
      config = function()
        require('Comment').setup()
      end,
    })

    use({
      'kylechui/nvim-surround',
      config = function()
        require('nvim-surround').setup()
      end,
    })

    use({ 'christoomey/vim-sort-motion', keys = 'gs' })
    use({ 'junegunn/vim-easy-align', keys = 'ga' })
    use('kana/vim-textobj-user')
    use('kana/vim-textobj-line')
    use('kana/vim-textobj-entire')
    use('kana/vim-textobj-indent')
    use('tpope/vim-repeat')

    -- miscellaneous / automatic
    use('beauwilliams/focus.nvim')
    use('wincent/vim-clipper')
    use('lukas-reineke/indent-blankline.nvim')
    use('editorconfig/editorconfig-vim')
    use('ludovicchabant/vim-gutentags')

    -- treesitter
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

    -- theme / status line / tmux / terminal / quickfix / vim
    use('navarasu/onedark.nvim')
    use('christoomey/vim-tmux-navigator')
    use('wincent/terminus')
    use('kevinhwang91/nvim-bqf')
    use('milkypostman/vim-togglelist')
    use('nvim-lualine/lualine.nvim')
    use({ 'akinsho/bufferline.nvim', tag = '*' })
    use('tpope/vim-unimpaired')
    use('tpope/vim-abolish')

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
