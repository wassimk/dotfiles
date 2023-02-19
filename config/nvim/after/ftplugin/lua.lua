--
-- lua filetype
--

local capabilities = require('w.lsp').capabilities()
local on_attach = require('w.lsp').on_attach

require('neodev').setup({
  library = {
    plugins = { 'nvim-treesitter', 'plenary.nvim', 'nvim-dap', 'gitsigns.nvim', 'nvim-dap-ui' },
  },
})

require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim', 'hs', 'packer_plugins' } },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format()
  end,
  group = vim.api.nvim_create_augroup('WamAutocmdsLuaFormatting', {}),
})
