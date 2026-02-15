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
        'codelldb',
        'codespell',
        'commitlint',
        'copilot-language-server',
        'glow',
        'luacheck',
        'prettierd',
        'ripper-tags', -- used by vim-gutentags
        'selene',
        'shellcheck', -- used by bash-language-server
        'stylua',
        'tailwindcss-language-server',
        'typescript-language-server', -- used by typescript-tools
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 10000,
      debounce_hours = 5,
    })
  end,
}
