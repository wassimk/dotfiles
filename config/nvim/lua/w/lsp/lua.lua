--
-- lua language server
--

require('neodev').setup({
  library = {
    plugins = {
      'gitsigns.nvim',
      'nvim-dap',
      'nvim-dap-ui',
      'nvim-treesitter',
      'plenary.nvim',
    },
  },
})

require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {
      -- https://github.com/LuaLS/lua-language-server/wiki/Settings
      completion = { enable = true, showWord = 'Disable' },
      diagnostics = { globals = { 'hs' } },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
})
