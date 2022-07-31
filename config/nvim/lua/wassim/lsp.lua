----
-- lsp
----
local lsp_status = require('lsp-status')
lsp_status.register_progress()
lsp_status.config({
  diagnostics = false, -- using the built-in to lualine
  select_symbol = function(cursor_pos, symbol) -- sumneko_lua offers more capabilities for ranges
    if symbol.valueRange then
      local value_range = {
        ['start'] = {
          character = 0,
          line = vim.fn.byte2line(symbol.valueRange[1]),
        },
        ['end'] = {
          character = 0,
          line = vim.fn.byte2line(symbol.valueRange[2]),
        },
      }

      return require('lsp-status.util').in_range(cursor_pos, value_range)
    end
  end,
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

local on_attach = function(client, bufnr)
  local opts = { buffer = 0, silent = true }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gS', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting_seq_sync, opts)

  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end

  lsp_status.on_attach(client)
end

-- global diagnostic configuration
vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  signs = { priority = 10 },
  float = {
    source = 'if_many',
  },
})

-- automatic lsp server installs
require('mason').setup() -- does more but the lspconfig extension is all we use it for
require('mason-lspconfig').setup({ automatic_installation = { exclude = { 'solargraph' } } })

-- bash scripting
require('lspconfig').bashls.setup({ capabilities = capabilities, on_attach = on_attach })

-- vimscript
require('lspconfig').vimls.setup({
  init_options = { isNeovim = true },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- yaml
require('lspconfig').yamlls.setup({ capabilities = capabilities, on_attach = on_attach })

-- json
require('lspconfig').jsonls.setup({ capabilities = capabilities, on_attach = on_attach })

-- html
require('lspconfig').html.setup({ capabilities = capabilities, on_attach = on_attach })

-- css
require('lspconfig').cssls.setup({ capabilities = capabilities, on_attach = on_attach })

-- rust
require('lspconfig').rust_analyzer.setup({
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        allFeatures = true,
        overrideCommand = {
          'cargo',
          'clippy',
          '--workspace',
          '--message-format=json',
          '--all-targets',
          '--all-features',
        },
      },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- ruby / solargraph
require('lspconfig').solargraph.setup({
  cmd = { 'bundle', 'exec', 'solargraph', 'stdio' },
  init_options = {
    formatting = false,
  },
  settings = {
    solargraph = {
      diagnostics = true,
      logLevel = 'debug',
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- javascript / typescript
-- this plugin calls lspconfig and sets up tsserver
require('typescript').setup({
  disable_commands = false,
  debug = false,
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
  },
})

-- eslint
require('lspconfig').eslint.setup({
  settings = {
    validate = 'on',
    codeAction = {
      disableRuleComment = {
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- lua
require('lspconfig').sumneko_lua.setup({
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim', 'hs' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

----
-- null-ls
----
local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd.with({ extra_filetypes = { 'ruby' } }),
  },
})
