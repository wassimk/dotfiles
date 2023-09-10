--
-- javascriptreact filetype
--

local auGroup = vim.api.nvim_create_augroup('WamAutocmdsJavaScriptReactFormatting', {})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format()

    -- https://github.com/pmizio/typescript-tools.nvim/blob/master/lua/typescript-tools/user_commands.lua
    -- require('typescript-tools.api').sort_imports(true)
    -- require('typescript-tools.api').organize_imports(true)
    -- require('typescript-tools.api').remove_unused(true)
    -- require('typescript-tools.api').remove_unused_imports(true)
    -- require('typescript-tools.api').add_missing_imports(true)
    require('typescript-tools.api').fix_all(true)

    vim.cmd('silent! EslintFixAll')
  end,
  group = auGroup,
})

-- add Rails JS/TS files to path
vim.opt.path:append('app/javascript')
