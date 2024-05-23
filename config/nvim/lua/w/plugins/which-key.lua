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

    wk.register({
      ['#'] = 'which_key_ignore',
      ['g#'] = 'which_key_ignore',
      ['*'] = 'which_key_ignore',
      ['g*'] = 'which_key_ignore',
      ['n'] = 'which_key_ignore',
      ['N'] = 'which_key_ignore',
      ['/'] = 'which_key_ignore',
      ['?'] = 'which_key_ignore',
      ['<leader>n'] = 'which_key_ignore',
      ['h'] = 'which_key_ignore',
      ['j'] = 'which_key_ignore',
      ['k'] = 'which_key_ignore',
      ['l'] = 'which_key_ignore',
      -- ['f'] = 'which_key_ignore',
      -- ['F'] = 'which_key_ignore',
      -- ['t'] = 'which_key_ignore',
      -- ['T'] = 'which_key_ignore',
      ['Y'] = 'Yank to end of line',
      ['<2-LeftMouse>'] = 'Match double clicked word',
      ['gl'] = 'lsp prefix',
      ['gr'] = 'selection prefix',
      ['<leader>d'] = 'dap/diagnostics prefix',
      ['<leader>h'] = 'gitsigns / harpoon prefix',
      ['<leader>hd'] = 'diff prefix',
      ['<leader>t'] = 'testing prefix',
      ['<C-f>'] = 'telescope prefix',
      ['<M-r>'] = 'harpoon prefix',
    })
  end,
}
