--
-- treesitter
--

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'c',
    'comment',
    'css',
    'dockerfile',
    'go',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'regex',
    'ruby',
    'rust',
    'scheme',
    'scss',
    'sql',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gri',
      node_incremental = 'grn',
      node_decremental = 'grp',
      scope_incremental = 'grs',
    },
  },
  indent = { enable = true },
  query_linter = { enable = true },
  autotag = { enable = true }, -- nvim-ts-autotag
  endwise = { enable = true }, -- nvim-treesitter-endwise
  matchup = { enable = true }, -- vim-matchup
})

-- folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99
