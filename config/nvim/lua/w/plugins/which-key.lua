--
-- which-key
-- https://github.com/folke/which-key.nvim
--

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  dependencies = {
    'echasnovski/mini.icons',
  },
  config = function()
    local wk = require('which-key')

    wk.setup({
      preset = 'helix',
      show_help = false,
      plugins = {
        spelling = {
          enabled = false,
        },
      },
    })

    wk.add({
      { '#', hidden = true },
      { '*', hidden = true },
      { '/', hidden = true },
      { '<leader>n', hidden = true },
      { '?', hidden = true },
      { 'N', hidden = true },
      { 'g#', hidden = true },
      { 'g*', hidden = true },
      { 'h', hidden = true },
      { 'j', hidden = true },
      { 'k', hidden = true },
      { 'l', hidden = true },
      { 'n', hidden = true },
      { '<2-LeftMouse>', desc = 'Match double clicked word' },
      { '<C-f>', desc = 'snacks', icon = '🍬' },
      { '<M-r>', desc = 'harpoon', icon = '🎯' },
      { '<leader><Space>', desc = 'miscellaneous', icon = '✨' },
      { '<leader><Space>o', icon = '🔀' },
      { '<leader>e', icon = '🔄' },
      { '<leader>r', icon = '✏️' },
      { '<leader><Space>/', icon = '⌨️' },
      { '<leader><Space>b', icon = '📑' },
      { '<leader><Space>c', icon = '🔄' },
      { '<leader><Space>f', icon = '📂' },
      { '<leader><Space>g', icon = '🔍' },
      { '<leader><Space>h', icon = '❓' },
      { '<leader><Space>i', icon = '🎨' },
      { '<leader><Space>k', icon = '⌨️' },
      { '<leader><Space>p', icon = '🎛️' },
      { '<leader><Space>r', icon = '🕒' },
      { '<leader><Space>s', icon = '🔤' },
      { '<leader><Space>w', icon = '🔎' },
      { '<leader>a', group = 'ai', icon = '🤖' },
      { '<leader>ad', icon = '🔌' },
      { '<leader>al', icon = '🔧' },
      { '<leader>ap', icon = '💬' },
      { '<leader>at', icon = '📤' },
      { '<leader>d', group = 'debug/diagnostics', icon = '🐛' },
      { '<leader>dd', icon = '📄' },
      { '<leader>de', icon = '⚠️' },
      { '<leader>df', icon = '💬' },
      { '<leader>dn', icon = '⏭️' },
      { '<leader>do', icon = '📝' },
      { '<leader>dp', icon = '⏮️' },
      { '<leader>du', icon = '🎨' },
      { '<leader>dw', icon = '🌍' },
      { '<leader>h', desc = 'gitsigns / harpoon', icon = '📌' },
      { '<leader>hd', desc = 'diff', icon = '📊' },
      { '<leader>l', icon = '📝' },
      { '<leader>q', icon = '📋' },
      { '<leader>t', desc = 'testing', icon = '🧪' },
      { '<leader>x', icon = '▶️' },
      { '<leader>y', icon = '📋' },
      { 'Y', desc = 'Yank to end of line' },
      { 'gl', desc = 'lsp', icon = '💡' },
      { 'gr', desc = 'selection', icon = '📍' },
    })
  end,
}
