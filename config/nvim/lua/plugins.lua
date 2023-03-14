local M = {}

function M.setup()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)

  local configuration = {
    dev = {
      path = '~/Personal/neovim',
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  }

  local plugins = {
    -- profile neovim
    'lewis6991/impatient.nvim',
    { 'dstein64/vim-startuptime', cmd = 'StartupTime' },

    -- many plugins use these, so not listed as required on them
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',

    -- startup screen
    'goolord/alpha-nvim',

    -- git
    {
      'tpope/vim-fugitive',
      cmd = { 'GBrowse', 'Gdiff' },
      dependencies = {
        { 'tpope/vim-rhubarb' },
        { 'tpope/vim-dispatch' },
      },
    },

    { 'akinsho/git-conflict.nvim', version = '*' },
    { 'lewis6991/gitsigns.nvim', version = '*' },
    {
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewFileHistory' },
      config = function()
        require('lay.diffview').setup()
      end,
    },
    { 'wincent/vcs-jump', cmd = 'VcsJump', version = '*' },

    -- testing
    {
      'janko-m/vim-test',
      cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
      config = function()
        require('lazy.vim-test').setup()
      end,
    },

    -- terminal
    {
      'akinsho/toggleterm.nvim',
      version = '*',
      cmd = { 'ToggleTerm', 'TermExec' },
      keys = {
        { '<C-Bslash>', '<cmd>ToggleTerm<cr>', desc = 'ToggleTerm: toggle main terminal' },
      },
      config = function()
        require('lazy.toggleterm').setup()
      end,
    },

    -- lsp / copilot / diagnostics
    'folke/todo-comments.nvim',

    {
      'simrat39/symbols-outline.nvim',
      cmd = 'SymbolsOutline',
      config = true,
    },

    {
      cmd = { 'Trouble', 'TroubleToggle' },
      'folke/trouble.nvim',
      config = function()
        require('lazy.trouble').setup()
      end,
    },

    'williamboman/mason.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    {
      'neovim/nvim-lspconfig',
      dependencies = {
        { 'folke/neodev.nvim', version = '*' },
        'jose-elias-alvarez/typescript.nvim',
        'simrat39/rust-tools.nvim',
        'williamboman/mason-lspconfig.nvim',
      },
    },

    {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      event = 'InsertEnter',
      config = function()
        require('lazy.copilot').setup()
      end,
    },

    'j-hui/fidget.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'kosayoda/nvim-lightbulb',

    { 'ThePrimeagen/refactoring.nvim', config = true },

    -- debugging
    {
      'mfussenegger/nvim-dap',
      version = '*',
      dependencies = {
        { 'rcarriga/nvim-dap-ui', version = '*' },
        'theHamsta/nvim-dap-virtual-text',
      },
    },

    -- completion / snippets
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
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
        { 'wassimk/cmp-rails-fixture-types', ft = 'ruby', dev = true },
        { 'wassimk/cmp-rails-fixture-names', ft = 'ruby', dev = true },
        { 'wassimk/cmp-feature-flipper', dev = true },
      },
    },

    {
      'L3MON4D3/LuaSnip',
      version = '*',
      dependencies = 'saadparwaiz1/cmp_luasnip',
    },

    -- ruby / rails
    {
      'vim-ruby/vim-ruby',
      ft = 'ruby',
      dependencies = {
        { 'tpope/vim-rails' },
      },
    },

    -- files and search
    {
      'wincent/ferret',
      version = '*',
      cmd = { 'Back', 'Quack' },
      keys = { '<Leader>a', '<Leader>s', '<Leader>r' },
    },
    { 'wincent/loupe', version = '*' },
    { 'wincent/scalpel', keys = '<Leader>e', version = '*' },

    {
      'ThePrimeagen/harpoon',
      keys = { '<Leader>h', '<C-e>' },
      config = function()
        require('lazy.harpoon').setup()
      end,
    },

    {
      'nvim-telescope/telescope.nvim',
      version = '*',
      dependencies = {
        'nvim-telescope/telescope-ui-select.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
    },

    {
      'kyazdani42/nvim-tree.lua',
      cmd = 'NvimTreeToggle',
      config = function()
        require('lazy.nvim-tree').setup()
      end,
    },

    -- markdown / gitcommit / text
    {
      'ellisonleao/glow.nvim',
      cmd = 'Glow',
      config = function()
        require('lazy.glow').setup()
      end,
    },

    {
      'andrewferrier/wrapping.nvim',
      config = true,
      ft = { 'markdown', 'gitcommit', 'text' },
    },

    -- text objects / motions
    {
      'numToStr/Comment.nvim',
      version = '*',
      keys = { 'gc', 'gcc', 'gbc' },
      config = true,
    },

    { 'kylechui/nvim-surround', version = '*', config = true },

    { 'kana/vim-textobj-entire', dependencies = 'kana/vim-textobj-user' },
    { 'kana/vim-textobj-indent', dependencies = 'kana/vim-textobj-user' },
    { 'kana/vim-textobj-line', dependencies = 'kana/vim-textobj-user' },

    'tpope/vim-repeat',

    'junegunn/vim-easy-align',
    { 'sQVe/sort.nvim', config = true, cmd = 'Sort' },

    -- miscellaneous / automatic
    'beauwilliams/focus.nvim',
    'ludovicchabant/vim-gutentags',
    'NvChad/nvim-colorizer.lua',
    { 'lukas-reineke/indent-blankline.nvim', version = '*' },
    { 'wincent/vim-clipper', version = '*' },

    -- treesitter / autopairs / autotag / endwise
    'hrsh7th/nvim-insx',

    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      dependencies = {
        'RRethy/nvim-treesitter-endwise',
        'andymass/vim-matchup',
        'nvim-treesitter/playground',
        'windwp/nvim-autopairs',
        'windwp/nvim-ts-autotag',
      },
    },

    -- theme / status line / tmux / terminal / quickfix / vim
    'christoomey/vim-tmux-navigator',
    'navarasu/onedark.nvim',
    'nvim-lualine/lualine.nvim',
    'tpope/vim-abolish',
    'tpope/vim-unimpaired',
    { 'akinsho/bufferline.nvim', version = '*' },
    {
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      version = '*',
      config = function()
        require('lazy.bqf').setup()
      end,
      dependencies = {
        'junegunn/fzf',
        run = function()
          vim.fn['fzf#install']()
        end,
      },
    },
  }

  require('lazy').setup(plugins, configuration)
end

return M
