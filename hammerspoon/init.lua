--
-- Hamerspoon Config
-- Install it first from - http://www.hammerspoon.org/
--

hs.window.animationDuration = 0 -- disable animations

local reloader = require('reloader')
local log = require('logger')
local u = require('utils')

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

APPS_TO_WINDOWS = {
  Allacrity = 1,
  Calendar = 4,
  Mail = 4,
  Messages = 5,
  Reminders = 5,
  Things = 5,
  Slack = 6,
}

local function moveableApp(appName)
  local moveableAppNames = u.tbl_keys(APPS_TO_WINDOWS)

  if u.tbl_contains(moveableAppNames, appName) then
    return true
  end
end

local function moveApp(app)
  local appWindow = app:mainWindow()
  local spaceId = APPS_TO_WINDOWS[app:name()] + 1

  if appWindow and spaceId then
    log.i('Moved ' .. app:name() .. ' to space ' .. APPS_TO_WINDOWS[app:name()])
    hs.spaces.moveWindowToSpace(appWindow, spaceId)
  end
end

WATCHER = hs.application.watcher
  .new(function(name, _, app)
    if moveableApp(name) then
      moveApp(app)
    end
  end)
  :start()

--
-- Auto-reload config on change.
--
reloader.init()

log.i('Config loaded')
