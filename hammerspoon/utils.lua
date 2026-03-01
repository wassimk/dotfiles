--
-- utils.lua
--

local M = {}

--- Checks if a list-like (vector) table contains `value`.
---
---@param t table Table to check
---@param value any Value to compare
---@return boolean `true` if `t` contains `value`
function M.tbl_contains(t, value)
  for _, v in ipairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

--- Return a list of all keys used in a table.
--- However, the order of the return table of keys is not guaranteed.
---
---@see From https://github.com/premake/premake-core/blob/master/src/base/table.lua
---
---@generic T: table
---@param t table<T, any> (table) Table
---@return T[] (list) List of keys
function M.tbl_keys(t)
  assert(type(t) == 'table', string.format('Expected table, got %s', type(t)))

  local keys = {}
  for k, _ in pairs(t) do
    table.insert(keys, k)
  end
  return keys
end

local function standardVisibleWindows(app)
  local result = {}
  for _, win in ipairs(app:allWindows()) do
    if win:isStandard() and win:isVisible() then
      table.insert(result, win)
    end
  end
  return result
end

local function processWindowQueue(queue, desktop, delay, onDone)
  local function step(index)
    if index > #queue then
      hs.timer.doAfter(0.5, onDone)
      return
    end
    SPACES.moveWindowToSpace(desktop, queue[index], function()
      hs.timer.doAfter(delay, function()
        step(index + 1)
      end)
    end)
  end

  if #queue == 0 then
    onDone()
  else
    step(1)
  end
end

function M.startWorking()
  -- Launch all apps
  hs.application.open('Slack')
  hs.application.open('Figma')
  hs.application.open('Tuple')
  hs.application.open('Things3')
  hs.application.open('Reminders')
  hs.application.open('Mimestream')
  hs.application.open('Calendar')
  local quickrefUrl = 'https://wassimk.github.io/quickref'
  local _, alreadyOpen = hs.osascript.applescript(string.format([[
    tell application "Safari"
      repeat with w in windows
        repeat with t in tabs of w
          if URL of t contains "%s" then return true
        end repeat
      end repeat
    end tell
    return false
  ]], quickrefUrl))
  if not alreadyOpen then
    hs.urlevent.openURLWithBundle(quickrefUrl, 'com.apple.Safari')
  end

  hs.timer.doAfter(2.0, function()
    local screens = hs.screen.allScreens()
    table.sort(screens, function(a, b)
      return a:frame().x < b:frame().x
    end)
    local leftScreen = screens[1]
    local rightScreen = screens[#screens]
    local gap = WINDOWS.GAP

    -- Left monitor: Reminders (left half), Things (right half)
    local lf = leftScreen:frame()
    local halfWidth = math.floor((lf.w - gap) / 2)

    local reminders = hs.application.find('Reminders')
    if reminders then
      local win = reminders:mainWindow()
      if win then
        win:moveToScreen(leftScreen)
        win:setFrame({ x = lf.x, y = lf.y, w = halfWidth, h = lf.h })
      end
    end

    local things = hs.application.find('Things3')
    if things then
      local win = things:mainWindow()
      if win then
        win:moveToScreen(leftScreen)
        win:setFrame({ x = lf.x + halfWidth + gap, y = lf.y, w = halfWidth, h = lf.h })
      end
    end

    -- Right monitor: Slack, Figma, Safari
    for _, appName in ipairs({ 'Slack', 'Figma', 'Safari' }) do
      local app = hs.application.find(appName)
      if app then
        local win = app:mainWindow()
        if win then
          win:moveToScreen(rightScreen)
        end
      end
    end

    -- Desktop 7: Calendar (left), Mimestream (right)
    local calendar = hs.application.find('Calendar')
    local mimestream = hs.application.find('Mimestream')
    local calWin = calendar and calendar:mainWindow()
    local mimeWin = mimestream and mimestream:mainWindow()

    local moveQueue = {}
    if calWin then table.insert(moveQueue, calWin) end
    if mimeWin then table.insert(moveQueue, mimeWin) end

    local function resizeDesktop7()
      if calWin and calWin:isVisible() then
        local screen = calWin:screen()
        local sf = screen:frame()
        local hw = math.floor((sf.w - gap) / 2)
        calWin:setFrame({ x = sf.x, y = sf.y, w = hw, h = sf.h })
      end
      if mimeWin and mimeWin:isVisible() then
        local screen = mimeWin:screen()
        local sf = screen:frame()
        local hw = math.floor((sf.w - gap) / 2)
        mimeWin:setFrame({ x = sf.x + hw + gap, y = sf.y, w = hw, h = sf.h })
      end
    end

    processWindowQueue(moveQueue, 7, 1.0, resizeDesktop7)
  end)
end

local function getWindowDesktopNumber(win)
  local ok, spaces = pcall(hs.spaces.windowSpaces, win:id())
  if not ok or not spaces or #spaces == 0 then return nil end

  local spaceId = spaces[1]
  local screen = win:screen()
  if not screen then return nil end

  local allSpaces = hs.spaces.spacesForScreen(screen:id())
  if not allSpaces then return nil end

  local desktopNum = 0
  for _, sid in ipairs(allSpaces) do
    local spaceType = hs.spaces.spaceType(sid)
    if spaceType == "user" then
      desktopNum = desktopNum + 1
      if sid == spaceId then
        return desktopNum
      end
    end
  end

  return nil
end

function M.startCoding()
  local ghosttyRunning = hs.application.find('ghostty') ~= nil
  local chromeRunning = hs.application.find('Google Chrome') ~= nil
  if not ghosttyRunning then
    hs.application.open('Ghostty')
  end
  if not chromeRunning then
    hs.application.open('Google Chrome')
  end

  local function positionWindows()
    local ghostty = hs.application.find('ghostty')
    local chrome = hs.application.find('Google Chrome')
    local screen = hs.screen.mainScreen()
    local sf = screen:frame()
    local gap = WINDOWS.GAP
    local leftWidth = math.floor((sf.w - gap) * 3 / 5)
    local rightWidth = sf.w - leftWidth - gap

    if ghostty then
      local win = ghostty:mainWindow()
      if win then
        win:setFrame({ x = sf.x, y = sf.y, w = leftWidth, h = sf.h })
      end
    end

    if chrome then
      local win = chrome:mainWindow()
      if win then
        win:setFrame({ x = sf.x + leftWidth + gap, y = sf.y, w = rightWidth, h = sf.h })
      end
    end
  end

  local function moveAndPosition()
    local ghostty = hs.application.find('ghostty')
    local moveQueue = {}
    if ghostty then
      local win = ghostty:mainWindow()
      if win and getWindowDesktopNumber(win) ~= 1 then
        table.insert(moveQueue, win)
      end
    end
    local chrome = hs.application.find('Google Chrome')
    if chrome then
      local win = chrome:mainWindow()
      if win and getWindowDesktopNumber(win) ~= 1 then
        table.insert(moveQueue, win)
      end
    end

    processWindowQueue(moveQueue, 1, 1.0, positionWindows)
  end

  if ghosttyRunning and chromeRunning then
    moveAndPosition()
  else
    hs.timer.doAfter(1.0, moveAndPosition)
  end
end

M.MEETING_DESKTOP = 6
local MEETING_DESKTOP = M.MEETING_DESKTOP

function M.startMeeting()
  hs.application.open('zoom.us')
  hs.application.open('granola')

  -- Wait for apps to launch before collecting windows
  hs.timer.doAfter(1.0, function()
    local zoom = hs.application.find('zoom.us')
    local granola = hs.application.find('granola')

    local allWindows = {}

    if zoom then
      for _, win in ipairs(standardVisibleWindows(zoom)) do
        table.insert(allWindows, { win = win, app = 'zoom' })
      end
    end

    if granola then
      for _, win in ipairs(standardVisibleWindows(granola)) do
        table.insert(allWindows, { win = win, app = 'granola' })
      end
    end

    -- Build move queue for windows not already on the meeting desktop
    local moveQueue = {}
    for _, entry in ipairs(allWindows) do
      if getWindowDesktopNumber(entry.win) ~= MEETING_DESKTOP then
        table.insert(moveQueue, entry.win)
      end
    end

    local function resizeAll()
      for _, entry in ipairs(allWindows) do
        local win = entry.win
        if win:isVisible() then
          local screen = win:screen()
          local sf = screen:frame()
          if entry.app == 'zoom' then
            local newWidth = 1280
            local newHeight = 1000
            win:setFrame({
              x = sf.x + (sf.w - newWidth) / 2,
              y = sf.y + 15,
              w = newWidth,
              h = newHeight,
            })
          elseif entry.app == 'granola' then
            local newWidth = 800
            local newHeight = 1200
            win:setFrame({
              x = sf.x + sf.w - newWidth - 15,
              y = sf.y + 15,
              w = newWidth,
              h = newHeight,
            })
          end
        end
      end
    end

    processWindowQueue(moveQueue, MEETING_DESKTOP, 1.0, resizeAll)
  end)
end

local SCREENCAST_DESKTOP = 5
local isScreencasting = false

function M.toggleScreencasting(appNames)
  if isScreencasting then
    isScreencasting = false
    hs.notify.new({ title = 'Screencast', informativeText = 'Screencast mode stopped' }):send()
  else
    M.resizeForScreencasting(appNames)
  end
end

function M.resizeForScreencasting(appNames)
  if isScreencasting then return end
  isScreencasting = true

  local mainScreen = hs.screen.mainScreen()
  local allWindows = {}
  local moveQueue = {}
  for _, appName in ipairs(appNames) do
    local app = hs.application.find(appName)
    if app and app.allWindows then
      local mainWin = app:mainWindow()
      for _, win in ipairs(standardVisibleWindows(app)) do
        table.insert(allWindows, win)
      end
      if mainWin and mainWin:isStandard() and mainWin:isVisible() then
        table.insert(moveQueue, mainWin)
      end
    end
  end

  -- Pull all windows from external monitors to main screen
  for _, win in ipairs(allWindows) do
    if win:screen():id() ~= mainScreen:id() then
      win:moveToScreen(mainScreen)
    end
  end

  local function resizeAll()
    for _, win in ipairs(allWindows) do
      if win:isVisible() then
        local screen = win:screen()
        local sf = screen:frame()
        win:setFrame({
          x = sf.x + (sf.w - 1280) / 2,
          y = sf.y + 25,
          w = 1280,
          h = 720,
        })
      end
    end
    hs.notify.new({ title = 'Screencast', informativeText = 'Screencast mode active' }):send()
  end

  -- Move main windows to screencast desktop, then resize
  if #moveQueue == 0 then
    resizeAll()
  else
    hs.timer.doAfter(1.0, function()
      processWindowQueue(moveQueue, SCREENCAST_DESKTOP, 1.5, resizeAll)
    end)
  end
end

function M.printRunningApps()
  local apps = hs.application.runningApplications()
  for _, app in ipairs(apps) do
    print(app:name())
  end
end

return M
