--
-- ruby-lsp.nvim
-- https://github.com/wassimk/ruby-lsp.nvim
--

return {
  'wassimk/ruby-lsp.nvim',
  dev = true,
  lazy = false,
  opts = {
    lsp = {
      -- solargraph takes over in projects that bundle it
      auto_start = function()
        return not require('w.utils').installed_via_bundler('solargraph')
      end,
    },
    user_commands = true,
    executor = 'toggleterm',
    toggleterm = {
      direction = 'horizontal',
    },
  },
}
