--
-- diffview.nvim
-- https://github.com/sindrets/diffview.nvim
--

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewFileHistory' },
  config = function()
    require('diffview').setup({
      keymaps = {
        file_history_panel = {
          { 'n', 'l', require('diffview.actions').open_commit_log, { desc = 'Open the commit log panel.' } },
        },
      },
    })
  end,
}
