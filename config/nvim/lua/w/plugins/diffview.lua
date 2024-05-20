--
-- diffview.nvim
-- https://github.com/sindrets/diffview.nvim
--

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewFileHistory', 'DiffviewOpen' },
  config = function()
    require('diffview').setup({
      enhanced_diff_hl = true,
      default_args = {
        DiffviewFileHistory = { '--no-merges' },
      },
      keymaps = {
        file_history_panel = {

          { 'n', 'l', require('diffview.actions').open_commit_log, { desc = 'Open the commit log panel' } },
          { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close the file history panel and diff views' } },
          {
            'n',
            '<C-v>',
            require('diffview.actions').goto_file_split,
            { desc = 'Open the file in a new split' },
          },
          {
            'n',
            '<C-t>',
            require('diffview.actions').goto_file_tab,
            { desc = 'Open the file in a new tabpage' },
          },
          ['<down>'] = false, -- use `j`
          ['<up>'] = false, -- use `k`
          ['L'] = false, -- use `l`
          ['<cr>'] = false, -- use `o`
          ['<C-w><C-f>'] = false, -- use `<C-v>`
          ['<C-w>gf'] = false, -- use `<C-t>`
          ['<2-LeftMouse>'] = false, -- use keyboard
        },
        file_panel = {
          { 'n', 'l', require('diffview.actions').open_commit_log, { desc = 'Open the commit log panel' } },
          { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close the file panel and diff views' } },
          {
            'n',
            '<C-v>',
            require('diffview.actions').goto_file_split,
            { desc = 'Open the file in a new split' },
          },
          {
            'n',
            '<C-t>',
            require('diffview.actions').goto_file_tab,
            { desc = 'Open the file in a new tabpage' },
          },
          ['<down>'] = false, -- use `j`
          ['<up>'] = false, -- use `k`
          ['L'] = false, -- use `o`
          ['<cr>'] = false, -- use `o`
          ['<C-w><C-f>'] = false, -- use `<C-v>`
          ['<C-w>gf'] = false, -- use `<C-t>`
          ['<2-LeftMouse>'] = false, -- use keyboard
          ['-'] = false, -- use `s`
        },
      },
    })
  end,
}
