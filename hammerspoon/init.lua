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
  local appNames = { 'Code', 'Google Chrome', 'Notion', 'Safari', 'com.superlogical.rex' }
  local chooser = hs.chooser.new(function(choice)
    if not choice then return end
    if choice.value == 'all' then
      U.resizeForScreencasting(appNames)
    elseif choice.value == 'desktop' then
      U.screencastCurrentDesktop()
    elseif choice.value == 'focused' then
      U.screencastFocusedWindow()
    elseif choice.value == 'compact' then
      U.screencastCompactWindow()
    end
  end)
  chooser:choices({
    { text = 'Current Desktop', subText = 'Resize all apps on the current desktop to 1600x900', value = 'desktop' },
    { text = 'Focused Window', subText = 'Resize the focused window to 1600x900', value = 'focused' },
    { text = 'Compact Window', subText = 'Resize for GIF recording (~100x28 terminal)', value = 'compact' },
    { text = 'All Apps', subText = 'Move all apps to desktop 5 and resize', value = 'all' },
  })
  chooser:show()
end)

hs.hotkey.bind(hyper, '6', function()
  U.startMeeting()
end)

-- Quick Entry (bindings handled by each app: Things, Raycast, Notion, Trailer)

-- Quick Launch
hs.hotkey.bind(hyper, 'A', function() hs.application.launchOrFocus('Claude') end)
hs.hotkey.bind(hyper, 'B', function() hs.application.launchOrFocus('Google Chrome') end)
hs.hotkey.bind(hyper, 'D', function() hs.application.launchOrFocus('Things3') end)
hs.hotkey.bind(hyper, 'E', function() hs.application.launchOrFocus('Messages') end)
hs.hotkey.bind(hyper, 'F', function() hs.application.launchOrFocus('Reminders') end)
hs.hotkey.bind(hyper, 'G', function() hs.application.launchOrFocus('Granola') end)
hs.hotkey.bind(hyper, 'I', function() hs.application.launchOrFocus('Mimestream') end)
hs.hotkey.bind(hyper, 'L', function() hs.application.launchOrFocus('Calendar') end)
hs.hotkey.bind(hyper, 'M', function() hs.application.launchOrFocus('Mail') end)
hs.hotkey.bind(hyper, 'O', function() hs.application.launchOrFocus('Notes') end)
hs.hotkey.bind(hyper, 'S', function() hs.application.launchOrFocus('Snagit') end)
hs.hotkey.bind(hyper, 'T', function() hs.application.launchOrFocusByBundleID('com.superlogical.rex') end)
hs.hotkey.bind(hyper, 'U', function() hs.application.launchOrFocus('Music') end)
hs.hotkey.bind(hyper, 'W', function() hs.application.launchOrFocus('1Password') end)
hs.hotkey.bind(hyper, 'Q', function() hs.application.launchOrFocus('Slack') end)
hs.hotkey.bind(hyper, 'X', function() hs.application.launchOrFocus('Notion') end)
hs.hotkey.bind(hyper, 'Z', function() hs.application.launchOrFocus('zoom.us') end)

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
        { key = 'N', label = 'Notion' },
        { key = 'R', label = 'Quick add reminder' },
        { key = 'K', label = 'Raycast AI' },
        { key = 'H', label = 'Things' },
        { key = 'P', label = 'Trailer' },
        { separator = 'Clipboard' },
        { key = 'C', label = 'Raycast Clipboard' },
      },
    },
    {
      title = 'Quick Launch',
      items = {
        { key = 'W', label = '1Password' },
        { key = 'L', label = 'Calendar' },
        { key = 'B', label = 'Chrome' },
        { key = 'A', label = 'Claude' },
        { key = 'G', label = 'Granola' },
        { key = 'M', label = 'Mail' },
        { key = 'E', label = 'Messages' },
        { key = 'I', label = 'Mimestream' },
        { key = 'U', label = 'Music' },
        { key = 'O', label = 'Notes' },
        { key = 'X', label = 'Notion' },
        { key = 'F', label = 'Reminders' },
        { key = 'T', label = 'Rex' },
        { key = 'Q', label = 'Slack' },
        { key = 'S', label = 'Snagit' },
        { key = 'D', label = 'Things' },
        { key = 'Z', label = 'Zoom' },
      },
    },
  },
})
-- Meta bindings are handled by Raycast (Quicklinks + commands)
CHEATSHEET.register('meta', {
  modifiers = { 'ctrl', 'alt', 'shift' },
  holdTime = 1.0,
  title = 'Meta Key',
  sections = {
    {
      title = 'Raycast',
      items = {
        { key = 'E', label = 'Emoji & Symbols' },
      },
    },
    {
      title = 'Docs',
      items = {
        { key = 'G', label = 'Go' },
        { key = 'D', label = 'HTTP Status Codes' },
        { key = 'S', label = 'JavaScript' },
        { key = 'U', label = 'Lua' },
        { key = 'I', label = 'Minitest' },
        { key = 'A', label = 'Rails' },
        { key = 'R', label = 'Ruby' },
        { key = 'T', label = 'Rust' },
        { key = 'Y', label = 'TypeScript' },
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
