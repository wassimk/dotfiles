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
      { '<C-f>', desc = 'telescope' },
      { '<M-r>', desc = 'harpoon' },
      { '<leader><Space>', desc = 'miscellaneous' },
      { '<leader>d', desc = 'dap/diagnostics' },
      { '<leader>h', desc = 'gitsigns / harpoon' },
      { '<leader>hd', desc = 'diff' },
      { '<leader>t', desc = 'testing' },
      { 'Y', desc = 'Yank to end of line' },
      { 'gl', desc = 'lsp' },
      { 'gr', desc = 'selection' },
    })
  end,
}
