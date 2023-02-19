----
-- lsp
----
local utils = require('w.utils')
local capabilities = require('w.lsp').capabilities()
local on_attach = require('w.lsp').on_attach

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
