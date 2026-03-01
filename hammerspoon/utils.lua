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

    local function processQueue(index)
      if index > #moveQueue then
        hs.timer.doAfter(0.5, resizeDesktop7)
        return
      end
      local win = moveQueue[index]
      SPACES.moveWindowToSpace(7, win, function()
        hs.timer.doAfter(1.0, function()
          processQueue(index + 1)
        end)
      end)
    end

    if #moveQueue == 0 then
      resizeDesktop7()
    else
      processQueue(1)
    end
  end)
end

function M.startCoding()
  local ghostty = hs.application.find('ghostty')
  if not hs.application.find('Google Chrome') then
    hs.application.open('Google Chrome')
  end

  local function positionWindows()
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

  if hs.application.find('Google Chrome') then
    positionWindows()
  else
    hs.timer.doAfter(1.0, positionWindows)
  end
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

local MEETING_DESKTOP = 6

function M.startMeeting()
  hs.application.open('zoom.us')
  hs.application.open('granola')

  -- Wait for apps to launch before collecting windows
  hs.timer.doAfter(1.0, function()
    local zoom = hs.application.find('zoom.us')
    local granola = hs.application.find('granola')

    local allWindows = {}

    if zoom then
      for _, win in ipairs(zoom:allWindows()) do
        if win:isStandard() and win:isVisible() then
          table.insert(allWindows, { win = win, app = 'zoom' })
        end
      end
    end

    if granola then
      for _, win in ipairs(granola:allWindows()) do
        if win:isStandard() and win:isVisible() then
          table.insert(allWindows, { win = win, app = 'granola' })
        end
      end
    end

    -- Build move queue for windows not already on the meeting desktop
    local moveQueue = {}
    for _, entry in ipairs(allWindows) do
      local desktop = getWindowDesktopNumber(entry.win)
      if desktop ~= MEETING_DESKTOP then
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

    local function processQueue(index)
      if index > #moveQueue then
        hs.timer.doAfter(0.5, resizeAll)
        return
      end
      local win = moveQueue[index]
      SPACES.moveWindowToSpace(MEETING_DESKTOP, win, function()
        hs.timer.doAfter(1.0, function()
          processQueue(index + 1)
        end)
      end)
    end

    if #moveQueue == 0 then
      resizeAll()
    else
      processQueue(1)
    end
  end)
end

local SCREENCAST_DESKTOP = 5
local screencastState = {}
local isScreencasting = false

function M.toggleScreencasting(appNames)
  if isScreencasting then
    M.stopScreencasting()
  else
    M.resizeForScreencasting(appNames)
  end
end

function M.resizeForScreencasting(appNames)
  if isScreencasting then return end
  isScreencasting = true
  screencastState = {}

  -- Collect all visible standard windows
  local allWindows = {}
  for _, appName in ipairs(appNames) do
    local app = hs.application.find(appName)
    if app and app.allWindows then
      for _, win in ipairs(app:allWindows()) do
        if win:isStandard() and win:isVisible() then
          table.insert(allWindows, win)
        end
      end
    end
  end

  -- Save state and build move queue
  local moveQueue = {}
  for _, win in ipairs(allWindows) do
    local frame = win:frame()
    local desktop = getWindowDesktopNumber(win)
    screencastState[win:id()] = {
      frame = { x = frame.x, y = frame.y, w = frame.w, h = frame.h },
      desktop = desktop,
    }
    if desktop ~= SCREENCAST_DESKTOP then
      table.insert(moveQueue, win)
    end
  end

  -- Resize all collected windows to 1280x720 centered
  local function resizeAll()
    for _, win in ipairs(allWindows) do
      if win:isVisible() then
        local screen = win:screen()
        local sf = screen:frame()
        local newWidth = 1280
        local newHeight = 720
        local newX = sf.x + (sf.w - newWidth) / 2
        local newY = sf.y + 25
        win:setFrame({ x = newX, y = newY, w = newWidth, h = newHeight })
      end
    end
    hs.notify.new({ title = 'Screencast', informativeText = 'Screencast mode active' }):send()
  end

  -- Process moves sequentially, then resize
  local function processQueue(index)
    if index > #moveQueue then
      hs.timer.doAfter(0.5, resizeAll)
      return
    end
    local win = moveQueue[index]
    SPACES.moveWindowToSpace(SCREENCAST_DESKTOP, win, function()
      hs.timer.doAfter(1.0, function()
        processQueue(index + 1)
      end)
    end)
  end

  if #moveQueue == 0 then
    resizeAll()
  else
    processQueue(1)
  end
end

function M.stopScreencasting()
  if not isScreencasting then return end
  isScreencasting = false

  -- Build restore queue from saved state
  local restoreQueue = {}
  for winId, state in pairs(screencastState) do
    local win = hs.window.get(winId)
    if win and state.desktop and state.desktop ~= SCREENCAST_DESKTOP then
      table.insert(restoreQueue, { win = win, state = state })
    elseif win and state.frame then
      -- Window was already on desktop 5, just restore frame
      win:setFrame(state.frame)
    end
  end

  local function processRestore(index)
    if index > #restoreQueue then
      screencastState = {}
      hs.notify.new({ title = 'Screencast', informativeText = 'Screencast mode stopped' }):send()
      return
    end
    local entry = restoreQueue[index]
    SPACES.moveWindowToSpace(entry.state.desktop, entry.win, function()
      hs.timer.doAfter(0.5, function()
        entry.win:setFrame(entry.state.frame)
        hs.timer.doAfter(1.0, function()
          processRestore(index + 1)
        end)
      end)
    end)
  end

  if #restoreQueue == 0 then
    screencastState = {}
    hs.notify.new({ title = 'Screencast', informativeText = 'Screencast mode stopped' }):send()
  else
    processRestore(1)
  end
end

function M.printRunningApps()
  local apps = hs.application.runningApplications()
  for _, app in ipairs(apps) do
    print(app:name())
  end
end

return M
