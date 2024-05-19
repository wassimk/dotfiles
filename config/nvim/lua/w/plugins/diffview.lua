--
-- diffview.nvim
-- https://github.com/sindrets/diffview.nvim
--

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewFileHistory', 'DiffviewOpen' },
  config = function()
    require('diffview').setup({
      keymaps = {
        file_history_panel = {
          { 'n', 'l', require('diffview.actions').open_commit_log, { desc = 'Open the commit log panel.' } },
          { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close the commit panel and diff views.' } },
        },
        file_panel = {
          { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close the file panel and diff views.' } },
        },
      },
    })
  end,
}
