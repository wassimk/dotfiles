--
-- ruby language servers
--

local utils = require('w.utils')
local capabilities = require('w.lsp').capabilities()
local on_attach = require('w.lsp').on_attach

-- solargraph
if utils.installed_via_bundler('solargraph') then
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
        description = 'Build YARD documentation for installed gems',
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
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- ruby-lsp
if utils.installed_via_bundler('ruby%-lsp') then
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

  require('lspconfig').ruby_ls.setup({
    cmd = { 'bundle', 'exec', 'ruby-lsp' },
    init_options = {
      enabledFeatures = enabled_features,
    },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- syntax_tree
if utils.installed_via_bundler('syntax_tree') then
  require('lspconfig').syntax_tree.setup({
    cmd = { 'bundle', 'exec', 'stree', 'lsp' },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end
