--
-- lua filetype
--

-- format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format()
  end,
  group = vim.api.nvim_create_augroup('WamAutocmdsLuaFormatting', {}),
})

----
-- language servers
----
require('neodev').setup({
  library = {
    plugins = { 'nvim-treesitter', 'plenary.nvim', 'nvim-dap', 'gitsigns.nvim', 'nvim-dap-ui' },
  },
})

local root_files = {
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
  '.git',
}

vim.lsp.start({
  name = 'lua-language-server',
  cmd = { 'lua-language-server' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  filetypes = { 'lua' },
  settings = {
    Lua = {
      -- https://github.com/LuaLS/lua-language-server/wiki/Settings
      completion = { enable = true, showWord = 'Disable' },
      diagnostics = { globals = { 'vim', 'hs', 'packer_plugins' } },
      format = { enable = false },
      runtime = { version = 'LuaJIT' },
      telemetry = { enable = false },
    },
  },
  capabilities = require('w.lsp').capabilities(),
})
