--
-- mason.nvim, mason-lspconfig.nvim, mason-tool-installer.nvim
-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim
-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim

return {
  'williamboman/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('mason').setup()

    -- automatic lsp server installs
    require('mason-lspconfig').setup({
      automatic_installation = {
        exclude = { 'rubocop', 'ruby_ls', 'solargraph', 'syntax_tree' },
      },
    })

    -- mason auto-update
    require('mason-tool-installer').setup({
      ensure_installed = {
        'codelldb',
        'codespell',
        'commitlint',
        'glow',
        'luacheck',
        'prettierd',
        'ripper-tags', -- used by vim-gutentags
        'selene',
        'shellcheck', -- used by bash-language-server
        'stylua',
        'tailwindcss-language-server',
        'tsserver', -- used by typescript-tools.nvim
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 5000,
    })
  end,
}
