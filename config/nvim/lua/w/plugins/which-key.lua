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
      { '<C-f>', desc = 'telescope prefix' },
      { '<M-r>', desc = 'harpoon prefix' },
      { '<leader><Space>', desc = 'miscellaneous prefix' },
      { '<leader>d', desc = 'dap/diagnostics prefix' },
      { '<leader>h', desc = 'gitsigns / harpoon prefix' },
      { '<leader>hd', desc = 'diff prefix' },
      { '<leader>t', desc = 'testing prefix' },
      { 'Y', desc = 'Yank to end of line' },
      { 'gl', desc = 'lsp prefix' },
      { 'gr', desc = 'selection prefix' },
    })
  end,
}
