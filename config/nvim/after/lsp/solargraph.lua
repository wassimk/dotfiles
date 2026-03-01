local utils = require('w.utils')

return {
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
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'SolargraphDocumentGems', function()
      vim.lsp.buf_notify(0, '$/solargraph/documentGems')
    end, { desc = 'Build YARD documentation for installed gems' })

    vim.api.nvim_buf_create_user_command(bufnr, 'SolargraphDocumentGemsWithRebuild', function()
      vim.lsp.buf_notify(0, '$/solargraph/documentGems', { rebuild = true })
    end, { desc = 'Rebuild YARD documentation for installed gems' })

    vim.api.nvim_buf_create_user_command(bufnr, 'SolargraphCheckGemVersion', function()
      vim.lsp.buf_notify(0, '$/solargraph/checkGemVersion', { verbose = true })
    end, { desc = 'Check if a newer version of the gem is available' })

    vim.api.nvim_buf_create_user_command(bufnr, 'SolargraphRestartServer', function()
      vim.lsp.buf_notify(0, '$/solargraph/restartServer')
    end, { desc = 'Restart the Solargraph server' })
  end,
}
