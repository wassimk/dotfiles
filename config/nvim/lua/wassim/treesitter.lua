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
  indent = { enable = true },
  incremental_selection = { enable = true },
  autopairs = { enable = true }, -- nvim-autopairs
  autotag = { enable = true }, -- nvim-ts-autotag
})

-- folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99
