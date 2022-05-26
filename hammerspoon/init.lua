--
-- Hamerspoon Config
-- Install it first from - http://www.hammerspoon.org/
--

hs.window.animationDuration = 0 -- disable animations

local reloader = require 'reloader'
local log = require 'logger'

hs.hotkey.bind(
  { 'ctrl', 'alt', 'cmd' }, 'f5', (function()
    hs.notify.new { title = 'Hammerspoon', informativeText = 'Config reloaded' }:send()
    hs.reload()
  end)
)

--
-- Auto-reload config on change.
--
reloader.init()

log.i('Config loaded')
