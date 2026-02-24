--
-- Hamerspoon Config
-- Install it first from - http://www.hammerspoon.org/
--

hs.window.animationDuration = 0 -- disable animations

RELOADER = require('reloader')
LOG = require('logger')
U = require('utils')
SPACES = require('spaces')

--
-- Keybindings
--

hs.hotkey.bind({ 'ctrl', 'shift', 'alt' }, 'f3', function()
  hs.notify.new({ title = 'Meeting', informativeText = 'Resize for meeting' }):send()
  U.resizeForMeeting()
end)

-- Double F4 detection for screencast toggle
local f4Timer = nil
local f4PressCount = 0

hs.hotkey.bind({ 'ctrl', 'shift', 'alt' }, 'f4', function()
  f4PressCount = f4PressCount + 1

  if f4Timer then
    f4Timer:stop()
  end

  f4Timer = hs.timer.doAfter(0.3, function()
    if f4PressCount == 1 then
      -- Single press - start screencast
      hs.notify.new({ title = 'Screencast', informativeText = 'Starting screencast mode' }):send()
      U.resizeForScreencasting({ 'Asana', 'Code', 'Ghostty', 'Google Chrome', 'Granola', 'Notion', 'Safari' })
    elseif f4PressCount >= 2 then
      -- Double press - stop screencast
      hs.notify.new({ title = 'Screencast', informativeText = 'Stopping screencast mode' }):send()
      U.stopScreencasting()
    end
    f4PressCount = 0
  end)
end)

hs.hotkey.bind({ 'ctrl', 'shift', 'alt' }, 'f5', function()
  hs.notify.new({ title = 'Hammerspoon', informativeText = 'Config reloaded' }):send()
  hs.reload()
end)

-- Move focused window to desktop N (ctrl+shift+alt + number)
for i = 1, 9 do
  hs.hotkey.bind({ 'ctrl', 'shift', 'alt' }, tostring(i), function()
    SPACES.moveWindowToSpace(i)
  end)
end

--
-- Auto-reload config on change.
--
RELOADER.init()

LOG.i('Config loaded')
