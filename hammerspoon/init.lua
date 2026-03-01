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
CHEATSHEET = require('cheatsheet')

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

--
-- Cheatsheet (hold hyper for 1 second)
--

CHEATSHEET.register('hyper', {
  modifiers = { 'cmd', 'ctrl', 'alt', 'shift' },
  holdTime = 0.5,
  title = 'Hyper Key',
  sections = {
    {
      title = 'Modes',
      items = {
        { key = '0', label = 'Working' },
        { key = '1', label = 'Coding' },
        { key = '5', label = 'Screencast' },
        { key = '6', label = 'Meeting' },
      },
    },
    {
      title = 'Quick Entry',
      items = {
        { key = 'H', label = 'Things' },
        { key = 'K', label = 'Raycast AI' },
        { key = 'N', label = 'Notion' },
        { key = 'P', label = 'Trailer' },
        { key = 'R', label = 'Quick add reminder' },
        { separator = 'Clipboard' },
        { key = 'C', label = 'Pastebot' },
      },
    },
    {
      title = 'Quick Launch',
      items = {
        { key = 'A', label = 'Asana' },
        { key = 'B', label = 'Chrome' },
        { key = 'E', label = 'Messages' },
        { key = 'G', label = 'Granola' },
        { key = 'I', label = 'Mimestream' },
        { key = 'L', label = 'Calendar' },
        { key = 'M', label = 'Mail' },
        { key = 'O', label = 'Notes' },
        { key = 'S', label = 'Snagit' },
        { key = 'T', label = 'Ghostty' },
        { key = 'Z', label = 'Zoom' },
      },
    },
  },
})
CHEATSHEET.start()

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
