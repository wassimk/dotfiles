---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      -- https://github.com/LuaLS/lua-language-server/wiki/Settings
      completion = { enable = true, showWord = 'Disable' },
      diagnostics = { globals = { 'vim', 'hs' } },
      hint = { enable = true, arrayIndex = 'Disable' },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
}
