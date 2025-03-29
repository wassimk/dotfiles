--
-- lua language server
--

return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      -- https://github.com/LuaLS/lua-language-server/wiki/Settings
      completion = { enable = true, showWord = 'Disable' },
      diagnostics = { globals = { 'vim', 'hs' } },
      hint = { enable = true, arrayIndex = 'Disable' },
      format = { enable = false },
      telemetry = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
}
