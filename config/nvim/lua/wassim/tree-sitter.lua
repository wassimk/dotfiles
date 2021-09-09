----
-- treesitter
----
require"nvim-treesitter.configs".setup {
  ensure_installed = {
    "bash", "comment", "css", "go", "html", "javascript", "json", "lua", "regex", "ruby", "scss",
    "typescript", "vim"
  },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  incremental_selection = { enable = true },
  autopairs = { enable = true }
}
