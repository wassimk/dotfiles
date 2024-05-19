--
-- go language server and go.nvim plugin
-- https://github.com/golang/tools/tree/master/gopls
-- https://github.com/ray-x/go.nvim
--

-- make sure lsp_cfg is false in go.nvim plugin config
local cfg = require('go.lsp').config()

cfg.capabilities = require('w.lsp').capabilities()
cfg.on_attach = require('w.lsp').on_attach

require('lspconfig').gopls.setup(cfg)
