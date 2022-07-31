--
-- javascript filetype
--

local auGroup = vim.api.nvim_create_augroup('WamAutocmdsJavaScriptFormatting', {})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    -- require('typescript').actions.addMissingImports({ sync = true })
    -- require('typescript').actions.organizeImports({ sync = true })
    require('typescript').actions.removeUnused({ sync = true })
    require('typescript').actions.fixAll({ sync = true })

    -- HACK: neovim 0.8 changed formatting_seq_sync to format
    vim.lsp.buf.format()
  end,
  group = auGroup,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  command = 'silent! EslintFixAll',
  group = auGroup,
})
