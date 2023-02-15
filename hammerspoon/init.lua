--
-- Hamerspoon Config
-- Install it first from - http://www.hammerspoon.org/
--

hs.window.animationDuration = 0 -- disable animations

RELOADER = require('reloader')
LOG = require('logger')
U = require('utils')

--
-- Keybindings
--

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f5', function()
  hs.notify.new({ title = 'Hammerspoon', informativeText = 'Config reloaded' }):send()
  hs.reload()
end)

--
-- Watch for Launching Applications and Move to Space
--

APP_TO_SPACE = {
  Alacritty = 1,
  Asana = 3,
  ['zoom.us'] = 3,
  Calendar = 4,
  Mail = 4,
  Messages = 5,
  Reminders = 5,
  Things = 5,
  Slack = 6,
}

function MOVEABLE_APP(app)
  local moveableAppNames = U.tbl_keys(APP_TO_SPACE)
  local appName = app:name()

  if U.tbl_contains(moveableAppNames, appName) then
    return true
  end
end

function YABAI_WINDOW_ID(app)
  local appPid = app:pid()
  local yabaiWindowIdCommand = 'yabai -m query --windows | jq \'.[] | select(.pid=="' .. appPid .. '") | .id\''
  local yabaiWindowId, _, _, _ = hs.execute(yabaiWindowIdCommand, true)

  return yabaiWindowId:gsub('[\n\r]', '')
end

function MOVE_APP(app)
  local spaceId = APP_TO_SPACE[app:name()]
  local yabaiWindowId = YABAI_WINDOW_ID(app)

  local yabaiMoveCommand = 'yabai -m window ' .. yabaiWindowId .. ' --space ' .. spaceId
  hs.execute(yabaiMoveCommand, true)
end

WATCHER = hs.application.watcher
  .new(function(_, event, app)
    if event == hs.application.watcher.launched and MOVEABLE_APP(app) then
      MOVE_APP(app)
    end
  end)
  :start()

--
-- Auto-reload config on change.
--
RELOADER.init()

LOG.i('Config loaded')
