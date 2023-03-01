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

    use({ 'akinsho/git-conflict.nvim', tag = '*' })
    use({ 'lewis6991/gitsigns.nvim', tag = '*' })
    use({ 'wincent/vcs-jump', cmd = 'VcsJump', tag = '*' })

    -- testing
    use({
      'janko-m/vim-test',
      cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
      config = function()
        require('lazy.vim-test').setup()
      end,
    })

    -- terminal
    use({ 'akinsho/toggleterm.nvim', tag = '*' })

    -- lsp / copilot / diagnostics
    use('folke/todo-comments.nvim')
    use({
      cmd = 'SymbolsOutline',
      'simrat39/symbols-outline.nvim',
      config = function()
        require('symbols-outline').setup()
      end,
    })

    use({
      cmd = 'Trouble',
      'folke/trouble.nvim',
      config = function()
        require('lazy.trouble').setup()
      end,
    })

    use('williamboman/mason.nvim')
    use('WhoIsSethDaniel/mason-tool-installer.nvim')

    use({
      'neovim/nvim-lspconfig',
      requires = {
        'folke/neodev.nvim',
        'jose-elias-alvarez/typescript.nvim',
        'simrat39/rust-tools.nvim',
        'williamboman/mason-lspconfig.nvim',
      },
    })

    use({
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      event = 'InsertEnter',
      config = function()
        require('lazy.copilot').setup()
      end,
    })

    use('j-hui/fidget.nvim')
    use('jose-elias-alvarez/null-ls.nvim')

    use({
      'ThePrimeagen/refactoring.nvim',
      module = 'refactoring',
      config = function()
        require('refactoring').setup()
      end,
    })

    -- debugging
    use({
      'mfussenegger/nvim-dap',
      tag = '*',
      requires = {
        { 'rcarriga/nvim-dap-ui', tag = '*' },
        'theHamsta/nvim-dap-virtual-text',
      },
    })

    -- completion / snippets
    use({
      'hrsh7th/nvim-cmp',
      requires = {
        'f3fora/cmp-spell',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-path',
        'onsails/lspkind.nvim',
        'petertriho/cmp-git',
        'ray-x/cmp-treesitter',
        'rcarriga/cmp-dap',
        { '~/personal/neovim/cmp-rails-fixture-types', ft = 'ruby' },
        { '~/personal/neovim/cmp-rails-fixture-names', ft = 'ruby' },
        { '~/personal/neovim/cmp-feature-flipper', ft = 'ruby' },
      },
    })

    use({
      'L3MON4D3/LuaSnip',
      tag = '*',
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
    use({ 'wincent/ferret', tag = '*' })
    use({ 'wincent/loupe', tag = '*' })
    use({ 'wincent/scalpel', keys = '<Leader>e', tag = '*' })

    use({
      'ThePrimeagen/harpoon',
      keys = { '<Leader>h', '<C-e>' },
      config = function()
        require('lazy.harpoon').setup()
      end,
    })

    use({
      'nvim-telescope/telescope.nvim',
      tag = '*',
      requires = {
        'nvim-telescope/telescope-dap.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      },
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
      tag = '*',
      keys = { 'gc', 'gcc', 'gbc' },
      config = function()
        require('Comment').setup()
      end,
    })

    use({
      'kylechui/nvim-surround',
      tag = '*',
      config = function()
        require('nvim-surround').setup()
      end,
    })

    use('kana/vim-textobj-entire')
    use('kana/vim-textobj-indent')
    use('kana/vim-textobj-line')
    use('kana/vim-textobj-user')
    use('tpope/vim-repeat')
    use({ 'christoomey/vim-sort-motion', keys = 'gs' })
    use({ 'junegunn/vim-easy-align' })

    -- miscellaneous / automatic
    use('beauwilliams/focus.nvim')
    use('ludovicchabant/vim-gutentags')
    use({ 'lukas-reineke/indent-blankline.nvim', tag = '*' })
    use({ 'wincent/vim-clipper', tag = '*' })

    -- treesitter
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        'RRethy/nvim-treesitter-endwise',
        'andymass/vim-matchup',
        'nvim-treesitter/playground',
        'windwp/nvim-autopairs',
        'windwp/nvim-ts-autotag',
      },
    })

    -- theme / status line / tmux / terminal / quickfix / vim
    use('christoomey/vim-tmux-navigator')
    use('milkypostman/vim-togglelist')
    use('navarasu/onedark.nvim')
    use('nvim-lualine/lualine.nvim')
    use('tpope/vim-abolish')
    use('tpope/vim-unimpaired')
    use({ 'akinsho/bufferline.nvim', tag = '*' })
    use({ 'kevinhwang91/nvim-bqf', tag = '*' })
    use({ 'wincent/terminus', tag = '*' })

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
