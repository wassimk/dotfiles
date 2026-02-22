--
-- ruby language servers
--

local utils = require('w.utils')

-- solargraph
if utils.installed_via_bundler('solargraph') then
  vim.lsp.enable({ 'solargraph' })
end

-- ruby-lsp
if utils.gemfile() and not utils.installed_via_bundler('solargraph') then
  vim.lsp.enable({ 'ruby_lsp' })
end

-- syntax_tree
if utils.installed_via_bundler('syntax_tree') then
  vim.lsp.enable({ 'syntax_tree' })
end

-- rubocop
if
  not utils.ruby_lsp_setup()
  and utils.installed_via_bundler('rubocop')
  and utils.config_exists('.rubocop.yml')
  and utils.rubocop_supports_lsp()
then
  vim.lsp.enable({ 'rubocop' })
end
