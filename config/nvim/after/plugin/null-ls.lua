--
-- null-ls.nvim
-- https://github.com/jose-elias-alvarez/null-ls.nvim
--

local null_ls = require('null-ls')
local utils = require('w.utils')

local sources = {
  null_ls.builtins.diagnostics.codespell,
  null_ls.builtins.diagnostics.commitlint.with({
    extra_args = { '--config', os.getenv('HOME') .. '/.commitlintrc.js' },
  }),
  null_ls.builtins.diagnostics.luacheck,
  null_ls.builtins.formatting.prettierd,
  null_ls.builtins.code_actions.refactoring.with({ extra_filetypes = { 'ruby' } }),
  null_ls.builtins.code_actions.shellcheck,
  null_ls.builtins.formatting.stylua,
  require('typescript.extensions.null-ls.code-actions'),
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

null_ls.setup({ sources = sources, on_attach = require('w.lsp').on_attach })
