----
-- lsp
----
local on_attach = function(client, bufnr)
  local opts = { buffer = 0, silent = true }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, opts)
end

-- configuration toggles
require('toggle_lsp_diagnostics').init { start_on = true, virtual_text = false, underline = false }

-- automatic lsp server installs
require('nvim-lsp-installer').setup { automatic_installation = { exclude = { 'solargraph' } } }

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- vimscript
require('lspconfig').vimls.setup { capabilities = capabilities, on_attach = on_attach }

-- ruby / solargraph
require 'lspconfig'.solargraph.setup {
  cmd = { 'bundle', 'exec', 'solargraph', 'stdio' },
  init_options = {
    formatting = false,
  },
  settings = {
    solargraph = {
      diagnostics = true,
    }
  },
  capabilities = capabilities,
  on_attach = on_attach
}

-- javascript / typescript
require('lspconfig').tsserver.setup { capabilities = capabilities, on_attach = on_attach }

-- eslint
require 'lspconfig'.eslint.setup { capabilities = capabilities, on_attach = on_attach }

-- lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = { path = runtime_path },
      diagnostics = { globals = { 'vim', 'hs' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      format = { enable = true },
      telemetry = { enable = false },
    }
  },
  capabilities = capabilities,
  on_attach = on_attach
}

----
-- formatting
----
local wamGrp = vim.api.nvim_create_augroup('WamAutocmdsFormatting', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.lua',
  command = 'lua vim.lsp.buf.formatting_seq_sync(nil, 100)',
  group = wamGrp,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rb',
  command = 'PrettierAsync',
  group = wamGrp,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
  command = 'EslintFixAll',
  group = wamGrp,
})
