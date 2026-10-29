-- Rex keybindings: keep the cmd-key muscle memory from tmux/herdr
-- https://www.superlogical.com/rex/docs/customize/keyboard-shortcuts
-- Apply with `rex config reload`, inspect with `rex keymap`

-- splits and zoom on the old keys
rex.bind("cmd+n", "pane.split.down")
rex.bind("cmd+shift+n", "pane.split.right")
rex.bind("cmd+z", "pane.zoom")

-- ...and off Rex's default keys
rex.unbind("cmd+shift+d") -- pane.split.down
rex.unbind("cmd+d") -- pane.split.right
rex.unbind("cmd+shift+enter") -- pane.zoom

rex.bind("cmd+shift+t", "pane.move_to_new_tab")
rex.bind("cmd+shift+k", "session.new")

rex.bind("shift+left", "pane.resize", { direction = "left" })
rex.bind("shift+right", "pane.resize", { direction = "right" })
rex.bind("shift+up", "pane.resize", { direction = "up" })
rex.bind("shift+down", "pane.resize", { direction = "down" })

-- ctrl-hjkl moves between panes and Neovim splits: the Rex side of
-- rex-navigator.nvim, from the local checkout or lazy.nvim's copy
local home = os.getenv("HOME")
package.path = table.concat({
  home .. "/Personal/neovim/rex-navigator.nvim/rex/?.lua",
  home .. "/.local/share/nvim/lazy/rex-navigator.nvim/rex/?.lua",
  package.path,
}, ";")
require("rex-navigator").setup()
