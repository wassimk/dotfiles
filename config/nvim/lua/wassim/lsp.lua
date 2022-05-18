----
-- lsp
----
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>de', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>dl', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
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

----
-- lua
----
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
