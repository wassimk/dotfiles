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
  Calendar = 4,
  Mail = 4,
  Messages = 5,
  Reminders = 5,
  Things = 5,
  Slack = 6,
}

function MOVEABLE_APP(appName)
  local moveableAppNames = U.tbl_keys(APP_TO_SPACE)

  if U.tbl_contains(moveableAppNames, appName) then
    return true
  end
end

function MOVE_APP(app)
  local appWindow = app:mainWindow()
  local spaceId = APP_TO_SPACE[app:name()] + 1

  if appWindow and spaceId then
    hs.spaces.moveWindowToSpace(appWindow, spaceId)
  end
end

WATCHER = hs.application.watcher
  .new(function(name, event, app)
    -- LOG.i('App event: ' .. name .. ' ' .. event .. ' ' .. app:name())
    if event == hs.application.watcher.launched and MOVEABLE_APP(name) then
      MOVE_APP(app)
    end
  end)
  :start()

--
-- Auto-reload config on change.
--
RELOADER.init()

LOG.i('Config loaded')
