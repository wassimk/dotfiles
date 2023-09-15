--
-- ruby language servers
--

local utils = require('w.utils')
local lspconfig = require('lspconfig')
local capabilities = require('w.lsp').capabilities()
local on_attach = require('w.lsp').on_attach

-- solargraph
if not utils.ruby_lsp_installed() and utils.installed_via_bundler('solargraph') then
  lspconfig.solargraph.setup({
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
if utils.ruby_lsp_installed() or not utils.installed_via_bundler('solargraph') then
  lspconfig.ruby_ls.setup({
    init_options = {
      formatter = 'rubocop',
      enabledFeatures = {
        'codeActions',
        'codeLens',
        'completion',
        'diagnostics',
        'documentHighlights',
        'documentLink',
        'documentSymbols',
        'foldingRanges',
        'formatting',
        'hover',
        'inlayHint',
        -- 'onTypeFormatting',
        'selectionRanges',
        'semanticHighlighting',
      },
    },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- syntax_tree
if utils.installed_via_bundler('syntax_tree') then
  lspconfig.syntax_tree.setup({
    cmd = { 'bundle', 'exec', 'stree', 'lsp' },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- rubocop
if
  not utils.ruby_lsp_installed()
  and utils.installed_via_bundler('rubocop')
  and utils.config_exists('.rubocop.yml')
  and utils.rubocop_supports_lsp()
then
  lspconfig.rubocop.setup({
    cmd = { 'bundle', 'exec', 'rubocop', '--lsp' },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end
