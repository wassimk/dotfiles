--
-- diffview.nvim
-- https://github.com/sindrets/diffview.nvim
--

local has_diffview, diffview = pcall(require, 'diffview')

if not has_diffview then
  return
end

local M = {}

function M.setup()
  diffview.setup({
    keymaps = {
      file_history_panel = {
        { 'n', 'l', require('diffview.actions').open_commit_log, { desc = 'Open the commit log panel.' } },
      },
    },
  })
end

return M
