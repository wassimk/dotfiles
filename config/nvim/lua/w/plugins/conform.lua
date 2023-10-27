--
-- confirm.nvim
-- https://github.com/stevearc/conform.nvim
--
return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { { 'prettierd' } },
      javascriptreact = { { 'prettierd' } },
      typescript = { { 'prettierd' } },
      typescriptreact = { { 'prettierd' } },
    },
    formatters = {
      prettierd = {
        condition = function()
          return require('w.utils').config_exists('.prettierrc')
        end,
      },
    },
  },
}
