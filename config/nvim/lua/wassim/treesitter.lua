----
-- treesitter
----
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'comment',
    'css',
    'html',
    'javascript',
    'json',
    'lua',
    'regex',
    'ruby',
    'rust',
    'scss',
    'toml',
    'typescript',
    'vim',
    'yaml',
  },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  incremental_selection = { enable = true },
  indent = { enable = true },
  autotag = { enable = true }, -- nvim-ts-autotag
  endwise = { enable = true }, -- nvim-treesitter-endwise
  matchup = { enable = true }, -- vim-matchup
})

-- nvim-autopairs - not a treesitter module but uses it
require('nvim-autopairs').setup({ check_ts = true, map_cr = true })

-- folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99
