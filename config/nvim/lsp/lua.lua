--
-- lua language server
--

local default_config = require('lspconfig.configs.lua_ls').default_config

local custom_config = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_dir = require('lspconfig.util').root_pattern('.luarc.json', '.luarc.jsonc', '.git'),
  settings = {
    Lua = {
      -- https://github.com/LuaLS/lua-language-server/wiki/Settings
      runtime = {
        version = 'LuaJIT',
      },
      completion = { enable = true, showWord = 'Disable' },
      diagnostics = { globals = { 'vim', 'hs', 'Snacks' } },
      hint = { enable = true, arrayIndex = 'Disable' },
      format = { enable = false },
      telemetry = { enable = false },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
    },
  },
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
}

return vim.tbl_deep_extend('force', default_config, custom_config)
