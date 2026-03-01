--
-- Hamerspoon Config
-- Install it first from - http://www.hammerspoon.org/
--

hs.window.animationDuration = 0 -- disable animations

RELOADER = require('reloader')
LOG = require('logger')
U = require('utils')
SPACES = require('spaces')
WINDOWS = require('windows')

--
-- Keybindings
--

local hyper = { 'cmd', 'ctrl', 'alt', 'shift' }

hs.hotkey.bind(hyper, '0', function()
  U.startWorking()
end)

hs.hotkey.bind(hyper, '1', function()
  U.startCoding()
end)

hs.hotkey.bind(hyper, '5', function()
  U.toggleScreencasting({ 'Asana', 'Code', 'Ghostty', 'Google Chrome', 'Notion', 'Safari' })
end)

hs.hotkey.bind(hyper, '6', function()
  U.startMeeting()
end)

-- Move focused window to desktop N (shift+alt + number)
for i = 1, 9 do
  hs.hotkey.bind({ 'shift', 'alt' }, tostring(i), function()
    local win = hs.window.focusedWindow()
    SPACES.moveWindowToSpace(i, nil, function()
      WINDOWS.snapToScreen(win)
    end)
  end)
end

--
-- Auto-reload config on change.
--
RELOADER.init()

LOG.i('Config loaded')
