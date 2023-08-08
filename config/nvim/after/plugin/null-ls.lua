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
  null_ls.builtins.code_actions.refactoring.with({ extra_filetypes = { 'ruby' } }),
  null_ls.builtins.code_actions.shellcheck,
  require('typescript.extensions.null-ls.code-actions'),
}

if utils.config_exists('.prettierrc') then
  vim.list_extend(sources, { null_ls.builtins.formatting.prettierd })
end

if utils.config_exists('.luacheckrc') then
  vim.list_extend(sources, { null_ls.builtins.diagnostics.luacheck })
end

if utils.config_exists('selene.toml') then
  vim.list_extend(sources, { null_ls.builtins.diagnostics.selene })
end

if utils.config_exists('stylua.toml') then
  vim.list_extend(sources, { null_ls.builtins.formatting.stylua })
end

if utils.installed_via_bundler('erb%-formatter') then
  local formatting_source = null_ls.builtins.formatting.erb_format.with({
    command = 'bundle',
    args = vim.list_extend({ 'exec', 'erb-format' }, null_ls.builtins.formatting.erb_format._opts.args),
  })

  vim.list_extend(sources, { formatting_source })
end

if utils.config_exists('.erb-lint.yml') then
  local diagnostic_source = null_ls.builtins.diagnostics.erb_lint.with({
    command = 'bundle',
    args = vim.list_extend({ 'exec', 'erblint' }, null_ls.builtins.diagnostics.erb_lint._opts.args),
  })

  local formatting_source = null_ls.builtins.formatting.erb_lint.with({
    command = 'bundle',
    args = vim.list_extend({ 'exec', 'erblint' }, null_ls.builtins.formatting.erb_lint._opts.args),
  })

  vim.list_extend(sources, { diagnostic_source, formatting_source })
end

null_ls.setup({ sources = sources, on_attach = require('w.lsp').on_attach })
