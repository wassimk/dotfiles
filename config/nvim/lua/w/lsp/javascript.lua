--
-- javascript/typescript shared formatting
--

local M = {}

function M.setup_formatting()
  local auGroup = vim.api.nvim_create_augroup('WamAutocmdsJavaScriptFormatting', {})

  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(event)
      require('typescript-tools.api').fix_all(true)

      local has_eslint = #vim.lsp.get_clients({ name = 'eslint', bufnr = event.buf }) > 0

      if has_eslint then
        vim.cmd('silent! EslintFixAll')
        vim.lsp.buf.format({ name = 'eslint' })
      else
        require('conform').format()
        vim.lsp.buf.format()
      end
    end,
    group = auGroup,
  })
end

return M
