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

hs.hotkey.bind({ 'ctrl', 'shift', 'alt' }, 'f4', function()
  hs.notify.new({ title = 'Screencast', informativeText = 'Resize for recording' }):send()
  U.resizeForScreencasting({ 'Alacritty', 'Asana', 'Code', 'Google Chrome', 'Notion', 'Safari', 'Slack' })
end)

hs.hotkey.bind({ 'ctrl', 'shift', 'alt' }, 'f5', function()
  hs.notify.new({ title = 'Hammerspoon', informativeText = 'Config reloaded' }):send()
  hs.reload()
end)

--
-- Auto-reload config on change.
--
RELOADER.init()

LOG.i('Config loaded')
