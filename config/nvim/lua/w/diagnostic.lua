----
-- diagnostic
----

-- global configuration
vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  signs = { priority = 10 },
  float = {
    source = 'if_many',
  },
})

-- icons in gutter
local diagnostic_signs = {
  Error = ' ',
  Warn = ' ',
  Info = ' ',
  Hint = ' ',
}

for type, icon in pairs(diagnostic_signs) do
  local hl = 'DiagnosticSign' .. type

  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end
