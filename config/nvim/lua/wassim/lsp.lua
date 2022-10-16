----
-- lsp
----
local utils = require('wassim.utils')

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client)
  local opts = { buffer = 0, silent = true }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gS', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>ds', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)

  if client.name == 'rust_analyzer' then
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', require('rust-tools').code_action_group.code_action_group, opts)
    vim.keymap.set('n', 'K', require('rust-tools').hover_actions.hover_actions, opts)
  else
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  end

  if client.name == 'tsserver' then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end
end

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
require('lspconfig').jsonls.setup({
  init_options = {
    provideFormatter = true,
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- html
require('lspconfig').html.setup({ capabilities = capabilities, on_attach = on_attach })

-- css
require('lspconfig').cssls.setup({ capabilities = capabilities, on_attach = on_attach })

-- syntax_tree
if utils.installed_via_bundler('syntax_tree') then
  require('lspconfig').syntax_tree.setup({
    cmd = { 'bundle', 'exec', 'stree', 'lsp' },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- ruby / solargraph
if utils.installed_via_bundler('solargraph') then
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

-- ruby-lsp
if utils.installed_via_bundler('ruby%-lsp') then
  local lspconfig = require('lspconfig')
  local configs = require('lspconfig.configs')
  local util = require('lspconfig.util')

  if not configs.ruby_lsp then
    local enabled_features = {
      'documentHighlights',
      'documentSymbols',
      'foldingRanges',
      'selectionRanges',
      'semanticHighlighting',
      -- 'formatting',
      'diagnostics',
      'codeActions',
    }

    configs.ruby_lsp = {
      default_config = {
        cmd = { 'bundle', 'exec', 'ruby-lsp' },
        filetypes = { 'ruby' },
        root_dir = util.root_pattern('Gemfile', '.git'),
        init_options = {
          enabledFeatures = enabled_features,
        },
      },
    }
  end

  lspconfig.ruby_lsp.setup({ on_attach = on_attach, capabilities = capabilities })
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

----
-- lua
----
require('neodev').setup({
  library = {
    plugins = { 'nvim-treesitter', 'plenary.nvim', 'nvim-dap', 'gitsigns.nvim' },
  },
})

require('lspconfig').sumneko_lua.setup({
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim', 'hs', 'packer_plugins' } },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

----
-- rust
----
-- use library from vscode CodeLLDB extension
local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.7.4/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

require('dap').adapters.lldb = {
  type = 'executable',
  attach = { pidProperty = 'pid', pidSelect = 'ask' },
  command = 'lldb-vscode',
  name = 'lldb',
  env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = 'YES' },
}

local opts = {
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
  },
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
  },
}

-- this plugin calls lspconfig and sets up rust-analyzer and nvim-dap
require('rust-tools').setup(opts)

----
-- null-ls
----
local null_ls = require('null-ls')
local sources = {
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.prettierd,
  null_ls.builtins.diagnostics.codespell,
  null_ls.builtins.diagnostics.commitlint.with({
    extra_args = { '--config', os.getenv('HOME') .. '/.commitlintrc.js' },
  }),
  null_ls.builtins.code_actions.shellcheck,
  null_ls.builtins.code_actions.refactoring.with({ extra_filetypes = { 'ruby' } }),
}

if utils.config_exists('selene.toml') then
  vim.list_extend(sources, { null_ls.builtins.diagnostics.selene })
end

-- rubocop via null-ls if not using solargraph or ruby-lsp
if
  (not utils.installed_via_bundler('solargraph') and not utils.installed_via_bundler('ruby%-lsp'))
  and utils.installed_via_bundler('rubocop')
  and utils.config_exists('.rubocop.yml')
then
  local rubocop_source = null_ls.builtins.diagnostics.rubocop.with({
    command = 'bundle',
    args = vim.list_extend({ 'exec', 'rubocop' }, null_ls.builtins.diagnostics.rubocop._opts.args),
  })

  vim.list_extend(sources, { rubocop_source })
end

null_ls.setup({ sources = sources, on_attach = on_attach })
