--
-- ruby-lsp.nvim
-- https://github.com/wassimk/ruby-lsp.nvim
--

return {
  'wassimk/ruby-lsp.nvim',
  dev = true,
  lazy = false, -- lsp/ruby_lsp.lua must be on the runtimepath before w.lsp.ruby enables the server
  opts = {
    user_commands = true,
    executor = 'toggleterm',
    toggleterm = {
      direction = 'horizontal',
    },
  },
}
