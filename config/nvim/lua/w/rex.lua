--
-- rex
--
-- Seamless <C-h/j/k/l> between neovim splits and Rex panes. Rex forwards the
-- keys to neovim when it is the focused program (~/.config/rex/init.lua), so
-- neovim moves between its own splits and asks Rex to focus the next pane
-- once there is no split left in that direction.
--

local M = {}

local directions = {
  h = 'left',
  j = 'down',
  k = 'up',
  l = 'right',
}

local function navigate(key)
  local win = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(key)

  -- a server call, the client's pane.focus.* actions need Remote Control
  if vim.api.nvim_get_current_win() == win and vim.env.REX_SESSION then
    vim.system({
      'rex',
      'do',
      '-e',
      string.format(
        'rex.call("session.focus_direction", { session_id = rex.session_id, direction = %q, wrap = false })',
        directions[key]
      ),
    })
  end
end

function M.setup()
  for key in pairs(directions) do
    vim.keymap.set('n', '<C-' .. key .. '>', function()
      navigate(key)
    end, { desc = 'Move to the split or Rex pane ' .. directions[key] })
  end
end

return M
