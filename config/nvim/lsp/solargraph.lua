--
-- Solargraph LSP
--

local utils = require('w.utils')
local default_config = require('lspconfig.configs.solargraph').default_config
default_config.root_dir = nil

local custom_config = {
  cmd = { 'bundle', 'exec', 'solargraph', 'stdio' },
  init_options = {
    formatting = false,
  },
  settings = {
    solargraph = {
      diagnostics = not utils.rubocop_supports_lsp(),
      logLevel = 'debug',
    },
  },
  commands = {
    SolargraphDocumentGems = {
      function()
        vim.lsp.buf_notify(0, '$/solargraph/documentGems')
      end,
      description = 'Build YARD documentation for installed gems',
    },
    SolargraphDocumentGemsWithRebuild = {
      function()
        vim.lsp.buf_notify(0, '$/solargraph/documentGems', { rebuild = true })
      end,
      description = 'Rebuild YARD documentation for installed gems',
    },
    SolargraphCheckGemVersion = {
      function()
        vim.lsp.buf_notify(0, '$/solargraph/checkGemVersion', { verbose = true })
      end,
      description = 'Check if a newer version of the gem is available',
    },
    SolargraphRestartServer = {
      function()
        vim.lsp.buf_notify(0, '$/solargraph/restartServer')
      end,
      description = 'A notification sent from the server to the client requesting that the client shut down and restart the server',
    },
  },
  capabilities = require('w.lsp').capabilities(),
  on_attach = require('w.lsp').on_attach,
}

return vim.tbl_deep_extend('force', default_config, custom_config)
