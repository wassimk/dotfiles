--
-- javascript filetype
--

require('w.lsp.javascript').setup_formatting()

-- add Rails JS/TS files to path
vim.opt.path:append('app/javascript')
