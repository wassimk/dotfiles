--
-- Hamerspoon Config
-- Install it first from - http://www.hammerspoon.org/
-- Most of this came directly from: github.com/wincent
--

hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.window.animationDuration = 0 -- disable animations

local screenCount = #hs.screen.allScreens()
local logLevel = 'info' -- generally want 'debug' or 'info'
local log = hs.logger.new('wam', logLevel)
local events = require 'events'
local reloader = require 'reloader'

local grid = {
  topHalf = '0,0 12x6',
  topThird = '0,0 12x4',
  topTwoThirds = '0,0 12x8',
  rightHalf = '6,0 6x12',
  rightThird = '8,0 4x12',
  rightTwoThirds = '4,0 8x12',
  bottomHalf = '0,6 12x6',
  bottomThird = '0,8 12x4',
  bottomTwoThirds = '0,4 12x8',
  leftHalf = '0,0 6x12',
  leftThird = '0,0 4x12',
  leftTwoThirds = '0,0 8x12',
  topLeft = '0,0 6x6',
  topRight = '6,0 6x6',
  bottomRight = '6,6 6x6',
  bottomLeft = '0,6 6x6',
  fullScreen = '0,0 12x12',
  centeredBig = '3,3 6x6',
  centeredSmall = '4,4 4x4',
}

local layoutConfig = {
  _before_ = (function()
    hide('com.twitter.twitter-mac')
  end),

  _after_ = (function()
    -- Make sure apps are in front of others
    -- activate('com.googlecode.iterm2')
    -- activate('com.kapeli.dashdoc')
  end),

  -- Full screen on single display or right half odd and left half even windows
  ['com.apple.Safari'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      -- First/odd windows go on the RIGHT side of the screen.
      -- Second/even windows go on the LEFT side.
      local windows = windowCount(window:application())
      local side = windows % 2 == 0 and grid.leftHalf or grid.rightHalf
      hs.grid.set(window, side, hs.screen.primaryScreen())
    end
  end),

  ['com.google.Chrome'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      -- First/odd windows go on the RIGHT side of the screen.
      -- Second/even windows go on the LEFT side.
      local windows = windowCount(window:application())
      local side = windows % 2 == 0 and grid.leftHalf or grid.rightHalf
      hs.grid.set(window, side, hs.screen.primaryScreen())
    end
  end),

  -- Full screen single display or left half of primary
  ['com.googlecode.iterm2'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      hs.grid.set(window, grid.leftTwoThirds, hs.screen.primaryScreen())
    end
  end),

  ['com.apple.mail'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      hs.grid.set(window, grid.leftHalf, hs.screen.primaryScreen())
    end
  end),

  -- Full screen single display or right half of primary
  ['com.github.atom'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      hs.grid.set(window, grid.rightTwoThirds, hs.screen.primaryScreen())
    end
  end),

  ['com.apple.iCal'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    elseif atWork() then
      hs.grid.set(window, grid.leftTwoThirds, internalDisplay())
    else
      hs.grid.set(window, grid.rightHalf, hs.screen.primaryScreen())
    end
  end),

  -- Always full screen internal or single display
  ['com.tinyspeck.slackmacgap'] = (function(window)
    if atWork() then
      hs.grid.set(window, grid.rightTwoThirds, internalDisplay())
    else
      hs.grid.set(window, grid.fullScreen, internalDisplay())
    end
  end),

  ['com.apple.dt.Xcode'] = (function(window)
    hs.grid.set(window, grid.fullScreen, internalDisplay())
  end),

  -- Always left half of internal or primary display
  ['com.apple.iChat'] = (function(window, forceScreenCount)
    hs.grid.set(window, grid.leftHalf, internalDisplay())
  end),

  -- Always right half of internal or single display
  ['com.skype.skype'] = (function(window)
    hs.grid.set(window, grid.rightHalf, internalDisplay())
  end)
}

--
-- Utility and helper functions.
--

-- Returns the number of standard, non-minimized windows in the application.
--
-- (For Chrome, which has two windows per visible window on screen, but only one
-- window per minimized window).
function windowCount(app)
  local count = 0
  if app then
    for _, window in pairs(app:allWindows()) do
      if window:isStandard() and not window:isMinimized() then
        count = count + 1
      end
    end
  end
  return count
end

function hide(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:hide()
  end
end

function activate(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:activate()
  end
end

function canManageWindow(window)
  local application = window:application()
  local bundleID = application:bundleID()

  -- Special handling for iTerm: windows without title bars are
  -- non-standard.
  return window:isStandard() or
    bundleID == 'com.googlecode.iterm2'
end

function atWork()
  return iMacDisplay()
end

function internalDisplay()
  if atWork() then
    -- External Acer Monitor at Work
    return hs.screen.find('1920x1080')
  else
  -- (Retina) MacBook Pro.
    return hs.screen.find('1440x900')
  end
end

function iMacDisplay()
   return hs.screen.find('2560x1440')
 end

function activateLayout(forceScreenCount)
  layoutConfig._before_()

  for bundleID, callback in pairs(layoutConfig) do
    local application = hs.application.get(bundleID)
    if application then
      local windows = application:visibleWindows()
      for _, window in pairs(windows) do
        if canManageWindow(window) then
          callback(window, forceScreenCount)
        end
      end
    end
  end

  layoutConfig._after_()
end

-- Event-handling
--
-- This will become a lot easier once `hs.window.filter`
-- (http://www.hammerspoon.org/docs/hs.window.filter.html) moves out of
-- "experimental" status, but until then, using a manual approach as
-- demonstrated at: https://gist.github.com/tmandry/a5b1ab6d6ea012c1e8c5
local globalWatcher = nil
local watchers = {}
local events = hs.uielement.watcher

-- Track the frontmost app that is NOT Hammerspoon
-- Mainly so I can get bundle id's easier! frontmost:bundleID()
frontmost = nil
hs.application.watcher.new(function(_, event, app)
  if (event == hs.application.watcher.activated
      and app:bundleID() ~= "org.hammerspoon.Hammerspoon") then
    frontmost = app
  end
end):start()

function handleGlobalEvent(name, eventType, app)
  if eventType == hs.application.watcher.launched then
    log.df('[event] launched %s', app:bundleID())
    watchApp(app)
  elseif eventType == hs.application.watcher.terminated then
    -- Only the PID is set for terminated apps, so can't log bundleID.
    local pid = app:pid()
    log.df('[event] terminated PID %d', pid)
    unwatchApp(pid)
  end
end

function handleAppEvent(element, event)
  if event == events.windowCreated then
    if pcall(function()
      log.df('[event] window %s created', element:id())
    end) then
      watchWindow(element)
    else
      log.wf('error thrown trying to access element in handleAppEvent')
    end
  else
    log.wf('unexpected app event %d received', event)
  end
end

function handleWindowEvent(window, event, watcher, info)
  if event == events.elementDestroyed then
    log.df('[event] window %s destroyed', info.id)
    watcher:stop()
    watchers[info.pid].windows[info.id] = nil
  else
    log.wf('unexpected window event %d received', event)
  end
end

function handleScreenEvent()
  -- Make sure that something noteworthy (display count) actually
  -- changed. We no longer check geometry because we were seeing spurious
  -- events.
  local screens = hs.screen.allScreens()
  if not (#screens == screenCount) then
    screenCount = #screens
    activateLayout(screenCount)
  end
end

function watchApp(app)
  local pid = app:pid()
  if watchers[pid] then
    log.wf('attempted watch for already-watched PID %d', pid)
    return
  end

  -- Watch for new windows.
  local watcher = app:newWatcher(handleAppEvent)
  watchers[pid] = {
    watcher = watcher,
    windows = {},
  }
  watcher:start({events.windowCreated})

  -- Watch already-existing windows.
  for _, window in pairs(app:allWindows()) do
    watchWindow(window)
  end
end

function unwatchApp(pid)
  local appWatcher = watchers[pid]
  if not appWatcher then
    log.wf('attempted unwatch for unknown PID %d', pid)
    return
  end

  appWatcher.watcher:stop()
  for _, watcher in pairs(appWatcher.windows) do
    watcher:stop()
  end
  watchers[pid] = nil
end

function watchWindow(window)
  local application = window:application()
  local bundleID = application:bundleID()
  local pid = application:pid()
  local windows = watchers[pid].windows
  if canManageWindow(window) then
    -- Do initial layout-handling.
    local bundleID = application:bundleID()
    if layoutConfig[bundleID] then
      layoutConfig[bundleID](window)
    end

    -- Watch for window-closed events.
    local id = window:id()
    if id then
      if not windows[id] then
        local watcher = window:newWatcher(handleWindowEvent, {
          id = id,
          pid = pid,
        })
        windows[id] = watcher
        watcher:start({events.elementDestroyed})
      end
    end
  end
end

function initEventHandling()
  -- Watch for application-level events.
  globalWatcher = hs.application.watcher.new(handleGlobalEvent)
  globalWatcher:start()

  -- Watch already-running applications.
  local apps = hs.application.runningApplications()
  for _, app in pairs(apps) do
    if app:bundleID() ~= 'org.hammerspoon.Hammerspoon' then
      watchApp(app)
    end
  end

  -- Watch for screen changes.
  screenWatcher = hs.screen.watcher.new(handleScreenEvent)
  screenWatcher:start()
end

function tearDownEventHandling()
  globalWatcher:stop()
  globalWatcher = nil

  screenWatcher:stop()
  screenWatcher = nil

  for pid, _ in pairs(watchers) do
    unwatchApp(pid)
  end
end

initEventHandling()

local lastSeenChain = nil
local lastSeenWindow = nil

function otherScreen()
  local win = hs.window.frontmostWindow()
  local screen = win:screen()
  local nextScreen = screen:next()

  hs.grid.set(win, grid.fullScreen, nextScreen)
end

-- Chain the specified movement commands.
--
-- This is like the "chain" feature in Slate, but with a couple of enhancements:
--
--  - Chains always start on the screen the window is currently on.
--  - A chain will be reset after 2 seconds of inactivity, or on switching from
--    one chain to another, or on switching from one app to another, or from one
--    window to another.
--
function chain(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval or
      lastSeenWindow ~= id
    then
      sequenceNumber = 1
      lastSeenChain = movements
    elseif (sequenceNumber == 1) then
      -- At end of chain, restart chain on next screen.
      screen = screen:next()
    end
    lastSeenAt = now
    lastSeenWindow = id

    hs.grid.set(win, movements[sequenceNumber], screen)
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

--
-- Key bindings.
--
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'space', (function()
  otherScreen()
end))

hs.hotkey.bind({'ctrl', 'alt'}, 'up', chain({
  grid.topHalf,
  grid.topThird,
  grid.topTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt'}, 'right', chain({
  grid.rightHalf,
  grid.rightThird,
  grid.rightTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt'}, 'down', chain({
  grid.bottomHalf,
  grid.bottomThird,
  grid.bottomTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt'}, 'left', chain({
  grid.leftHalf,
  grid.leftThird,
  grid.leftTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'up', chain({
  grid.topLeft,
  grid.topRight,
  grid.bottomRight,
  grid.bottomLeft,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'down', chain({
  grid.fullScreen,
  grid.centeredBig,
  grid.centeredSmall,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f1', (function()
  hs.alert('One-monitor layout')
  activateLayout(1)
end))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f2', (function()
  hs.alert('Two-monitor layout')
  activateLayout(2)
end))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f3', (function()
  hs.openConsole()
end))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f4', (function()
  hs.notify.new({title="Hammerspoon", informativeText="Menu toggled"}):send()
  hs.menuIcon(not hs.menuIcon())
end))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f5', (function()
  hs.notify.new({title="Hammerspoon", informativeText="Config reloaded"}):send()
  hs.reload()
end))

--
-- Auto-reload config on change.
--
function reloadConfig(files)
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      tearDownEventHandling()
      hs.reload()
    end
  end
end

reloader.init()

log.i('Config loaded')
