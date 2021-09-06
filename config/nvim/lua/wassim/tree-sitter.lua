----
-- tree-sitter
----
require"nvim-treesitter.configs".setup {
  ensure_installed = {
    "css", "html", "javascript", "json", "lua", "regex", "ruby", "scss", "typescript", "vim"
  },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  incremental_selection = { enable = true }
}
