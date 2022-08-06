----
-- lsp
----
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client)
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
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)

  -- HACK: neovim 0.8 changed formatting_seq_sync to format
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)

  if client.name == 'tsserver' then
    -- HACK: neovim 0.8 change client_capabilities => server_capabilities
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end
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

-- mason auto-update
-- TODO: move to its own file, this isn't realy lsp specific
require('mason-tool-installer').setup({
  ensure_installed = {
    'codespell',
    'prettierd',
    'selene',
    'shellcheck', -- used by bash-language-server
    'stylua',
  },
  auto_update = true,
  run_on_start = true,
  start_delay = 5000,
})

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

-- syntax_tree
if require('wassim.utils').installed_via_bundler('syntax_tree') then
  require('lspconfig').syntax_tree.setup({
    cmd = { 'bundle', 'exec', 'stree', 'lsp' },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- ruby / solargraph
if require('wassim.utils').installed_via_bundler('solargraph') then
  require('lspconfig').solargraph.setup({
    cmd = { 'bundle', 'exec', 'solargraph', 'stdio' },
    init_options = {
      formatting = false,
    },
    settings = {
      solargraph = {
        diagnostics = true,
      },
    },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- javascript / typescript
-- this plugin calls lspconfig and sets up tsserver
require('typescript').setup({
  disable_commands = false, -- :Typescript* commands
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
      diagnostics = { globals = { 'vim', 'hs', 'packer_plugins' } },
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
    null_ls.builtins.diagnostics.selene,
    null_ls.builtins.formatting.prettierd.with({ extra_filetypes = { 'ruby' } }),
    null_ls.builtins.diagnostics.codespell, -- TODO: if it works well switch to formatting version
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.code_actions.refactoring.with({ extra_filetypes = { 'ruby' } }),
  },
})
