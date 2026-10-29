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

-- ctrl-hjkl moves between panes, except in Neovim, which gets the key and
-- moves between its own splits, handing off to Rex at the edge
-- (config/nvim/lua/w/rex.lua)
local function in_vim()
  local ok, process = pcall(rex.block.call, "com.superlogical.terminal", "process", {})
  local fg = ok and process and process.foreground
  if not fg then
    return false
  end

  for _, name in ipairs({ fg.name or "", (fg.argv0 or ""):match("[^/]+$") or "" }) do
    if name:match("^n?vim$") then
      return true
    end
  end
  return false
end

-- bind the physical keys so the layout doesn't matter (Karabiner's emacs
-- rules must also skip Rex, or ctrl+h arrives as backspace)
for key, direction in pairs({ KeyH = "left", KeyJ = "down", KeyK = "up", KeyL = "right" }) do
  rex.bind("ctrl+[" .. key .. "]", function(ctx)
    if in_vim() then
      return false -- let the key through to Neovim
    end

    -- the server method, the client's pane.focus.* actions always wrap
    rex.call("session.focus_direction", {
      session_id = ctx.session_id,
      direction = direction,
      wrap = false,
    })
    return true
  end)
end
