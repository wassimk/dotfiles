----
-- ruby language servers
----

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
