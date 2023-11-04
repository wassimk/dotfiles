--
-- null-ls.nvim
-- https://github.com/jose-elias-alvarez/null-ls.nvim
--

return {
  'jose-elias-alvarez/null-ls.nvim',
  config = function()
    local null_ls = require('null-ls')
    local utils = require('w.utils')

    local sources = {}

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
  end,
}
