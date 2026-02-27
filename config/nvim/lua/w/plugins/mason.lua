--
-- mason.nvim, mason-tool-installer.nvim
-- https://github.com/williamboman/mason.nvim
-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim

return {
  'williamboman/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('mason').setup()

    -- mason auto-update
    require('mason-tool-installer').setup({
      ensure_installed = {
        'bash-language-server', -- lsp
        'codelldb', -- used by nvim-dap
        'codespell', -- used by nvim-lint
        'commitlint', -- used by nvim-lint
        'copilot-language-server',
        'css-lsp',
        'emmet-language-server',
        'eslint-lsp',
        'gopls', -- used by ray-x/go.nvim
        'html-lsp',
        'json-lsp',
        'lua-language-server',
        'luacheck', -- used by nvim-lint
        'prettierd', -- used by conform.nvim
        'selene', -- used by nvim-lint
        'shellcheck', -- used by bash-language-server
        'stylua', -- used by conform.nvim
        'tailwindcss-language-server',
        'typescript-language-server', -- used by typescript-tools.nvim
        'vim-language-server',
        'yaml-language-server',
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 10000,
      debounce_hours = 5,
    })
  end,
}
