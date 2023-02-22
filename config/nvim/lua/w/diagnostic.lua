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

-- keymaps
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dd', '<cmd>TroubleToggle document_diagnostics<cr>')
vim.keymap.set('n', '<leader>wd', '<cmd>TroubleToggle workspace_diagnostics<cr>')

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
