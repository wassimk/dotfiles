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
local function opts(desc)
  return {
    desc = 'DIAGNOSTIC: ' .. desc,
  }
end
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts('next'))
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts('previous'))
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, opts('open float'))
vim.keymap.set('n', '<leader>dd', '<cmd>Trouble document_diagnostics<cr>', opts('document list'))
vim.keymap.set('n', '<leader>dw', '<cmd>Trouble workspace_diagnostics<cr>', opts('workspace list'))

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
