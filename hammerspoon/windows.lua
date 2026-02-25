--
-- windows.lua - Window positioning and swapping
--

local M = {}

--
-- Positioning
--

-- Screens that should only ever be maximized (no halves).
-- Matched as a substring of the screen name.
local FULLSCREEN_ONLY = { 'LG UltraFine' }

local function isFullscreenOnly(screen)
  local name = screen:name() or ''
  for _, pattern in ipairs(FULLSCREEN_ONLY) do
    if name:find(pattern, 1, true) then return true end
  end
  return false
end

-- For full-screen-only monitors (e.g. portrait), use full width but only
-- the center two-thirds of the height so it's not absurdly tall.
local function fullscreenOnlyFrame(s)
  local margin = s.h / 6
  return { x = s.x, y = s.y + margin, w = s.w, h = s.h - 2 * margin }
end

-- Gap in pixels between adjacent tiled windows
local GAP = 4

-- Saved frames for maximize toggle (keyed by window ID)
local preMaximizeFrames = {}

-- Tolerance in pixels for "already in this position" checks
local TOLERANCE = 20

local function framesMatch(a, b)
  return math.abs(a.x - b.x) < TOLERANCE
    and math.abs(a.y - b.y) < TOLERANCE
    and math.abs(a.w - b.w) < TOLERANCE
    and math.abs(a.h - b.h) < TOLERANCE
end

-- Apply a position. If the window is already there, move to the next screen
-- in the given direction and apply the opposite position (so windows traverse
-- monitors half-by-half: right half → left half of next monitor, etc.)
-- Full-screen-only monitors always get maximized instead of halves.
local function setPosition(fn, nextScreenFn, crossFn)
  local win = hs.window.focusedWindow()
  if not win then return end

  local screen = win:screen()

  -- On a full-screen-only monitor, cross to the next screen if possible.
  -- If there's no screen in that direction, do nothing.
  if isFullscreenOnly(screen) then
    if nextScreenFn then
      local next = nextScreenFn(screen)
      if next then
        screen = next
        local apply = isFullscreenOnly(screen) and fullscreenOnlyFrame or (crossFn or fn)
        win:setFrame(apply(screen:frame()))
      end
    end
    return
  end

  local target = fn(screen:frame())

  if nextScreenFn and framesMatch(win:frame(), target) then
    local next = nextScreenFn(screen)
    if next then
      screen = next
      if isFullscreenOnly(screen) then
        win:setFrame(fullscreenOnlyFrame(screen:frame()))
        return
      end
      target = (crossFn or fn)(screen:frame())
    end
  end

  win:setFrame(target)
end

local function leftHalfFrame(s)
  local w = (s.w - GAP) / 2
  return { x = s.x, y = s.y, w = w, h = s.h }
end

local function rightHalfFrame(s)
  local w = (s.w - GAP) / 2
  return { x = s.x + w + GAP, y = s.y, w = w, h = s.h }
end

local function topHalfFrame(s)
  local h = (s.h - GAP) / 2
  return { x = s.x, y = s.y, w = s.w, h = h }
end

local function bottomHalfFrame(s)
  local h = (s.h - GAP) / 2
  return { x = s.x, y = s.y + h + GAP, w = s.w, h = h }
end

function M.leftHalf()
  setPosition(leftHalfFrame, function(scr) return scr:toWest() end, rightHalfFrame)
end

function M.rightHalf()
  setPosition(rightHalfFrame, function(scr) return scr:toEast() end, leftHalfFrame)
end

function M.topHalf()
  setPosition(topHalfFrame, function(scr) return scr:toNorth() end, bottomHalfFrame)
end

function M.bottomHalf()
  setPosition(bottomHalfFrame, function(scr) return scr:toSouth() end, topHalfFrame)
end

function M.maximize()
  local win = hs.window.focusedWindow()
  if not win then return end

  local screen = win:screen()
  if isFullscreenOnly(screen) then
    win:setFrame(fullscreenOnlyFrame(screen:frame()))
    return
  end

  local s = screen:frame()
  local maxFrame = { x = s.x, y = s.y, w = s.w, h = s.h }

  if framesMatch(win:frame(), maxFrame) then
    local saved = preMaximizeFrames[win:id()]
    if saved then
      win:setFrame(saved)
      preMaximizeFrames[win:id()] = nil
    else
      win:setFrame(leftHalfFrame(s))
    end
  else
    preMaximizeFrames[win:id()] = win:frame()
    win:setFrame(maxFrame)
  end
end

function M.center()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen():frame()
  local f = win:frame()
  win:setFrame({
    x = screen.x + (screen.w - f.w) / 2,
    y = screen.y + (screen.h - f.h) / 2,
    w = f.w,
    h = f.h,
  })
end

function M.leftThird()
  setPosition(function(s)
    local w = (s.w - 2 * GAP) / 3
    return { x = s.x, y = s.y, w = w, h = s.h }
  end)
end

function M.centerThird()
  setPosition(function(s)
    local w = (s.w - 2 * GAP) / 3
    return { x = s.x + w + GAP, y = s.y, w = w, h = s.h }
  end)
end

function M.rightThird()
  setPosition(function(s)
    local w = (s.w - 2 * GAP) / 3
    return { x = s.x + 2 * (w + GAP), y = s.y, w = w, h = s.h }
  end)
end

function M.leftTwoThirds()
  setPosition(function(s)
    local w = (s.w - 2 * GAP) / 3
    return { x = s.x, y = s.y, w = 2 * w + GAP, h = s.h }
  end)
end

function M.rightTwoThirds()
  setPosition(function(s)
    local w = (s.w - 2 * GAP) / 3
    return { x = s.x + w + GAP, y = s.y, w = 2 * w + GAP, h = s.h }
  end)
end

--
-- Swapping
--

-- Minimum size for a window to be considered a real swap candidate
local MIN_SWAP_SIZE = 200

-- Swap with a neighbor window. If no neighbor exists on the current screen,
-- move into the empty space on that side. Only cross to the next monitor
-- if already at the edge of the screen in that direction.
local function swapOrMove(directionFn, atEdgeFn, emptyFn, nextScreenFn, crossFn, axis)
  local win = hs.window.focusedWindow()
  if not win then return end

  -- Only consider real windows on the same screen (ignore tiny popups/panels)
  local neighbors = directionFn(win)
  local sameScreen = {}
  if neighbors then
    local winScreen = win:screen():id()
    for _, n in ipairs(neighbors) do
      local nf = n:frame()
      if n:screen():id() == winScreen
        and n:isStandard()
        and nf.w >= MIN_SWAP_SIZE
        and nf.h >= MIN_SWAP_SIZE then
        table.insert(sameScreen, n)
      end
    end
  end

  if #sameScreen > 0 then
    -- Swap with the nearest window on this screen
    local other = sameScreen[1]
    local wf = win:frame()
    local of = other:frame()
    local f1 = { x = wf.x, y = wf.y, w = wf.w, h = wf.h }
    local f2 = { x = of.x, y = of.y, w = of.w, h = of.h }

    -- Enforce gap between the two swapped positions
    if axis == 'h' then
      local left, right = f1, f2
      if f2.x < f1.x then left, right = f2, f1 end
      local adjust = (GAP - (right.x - (left.x + left.w))) / 2
      left.w = left.w - adjust
      right.x = right.x + adjust
      right.w = right.w - adjust
    elseif axis == 'v' then
      local top, bottom = f1, f2
      if f2.y < f1.y then top, bottom = f2, f1 end
      local adjust = (GAP - (bottom.y - (top.y + top.h))) / 2
      top.h = top.h - adjust
      bottom.y = bottom.y + adjust
      bottom.h = bottom.h - adjust
    end

    win:setFrame(f2)
    other:setFrame(f1)
  elseif atEdgeFn(win) then
    -- At the edge of the screen, cross to the next monitor
    local next = nextScreenFn(win:screen())
    if next then
      if isFullscreenOnly(next) then
        win:setFrame(fullscreenOnlyFrame(next:frame()))
      else
        win:setFrame(crossFn(next:frame()))
      end
    end
  else
    -- Empty space on this screen, move into it
    win:setFrame(emptyFn(win:screen():frame()))
  end
end

function M.swapLeft()
  swapOrMove(
    function(w) return w:windowsToWest(nil, false, false) end,
    function(w) return math.abs(w:frame().x - w:screen():frame().x) < TOLERANCE end,
    leftHalfFrame,
    function(scr) return scr:toWest() end,
    rightHalfFrame,
    'h'
  )
end

function M.swapRight()
  swapOrMove(
    function(w) return w:windowsToEast(nil, false, false) end,
    function(w)
      local f, s = w:frame(), w:screen():frame()
      return math.abs((f.x + f.w) - (s.x + s.w)) < TOLERANCE
    end,
    rightHalfFrame,
    function(scr) return scr:toEast() end,
    leftHalfFrame,
    'h'
  )
end

function M.swapUp()
  swapOrMove(
    function(w) return w:windowsToNorth(nil, false, false) end,
    function(w) return math.abs(w:frame().y - w:screen():frame().y) < TOLERANCE end,
    topHalfFrame,
    function(scr) return scr:toNorth() end,
    bottomHalfFrame,
    'v'
  )
end

function M.swapDown()
  swapOrMove(
    function(w) return w:windowsToSouth(nil, false, false) end,
    function(w)
      local f, s = w:frame(), w:screen():frame()
      return math.abs((f.y + f.h) - (s.y + s.h)) < TOLERANCE
    end,
    bottomHalfFrame,
    function(scr) return scr:toSouth() end,
    topHalfFrame,
    'v'
  )
end

--
-- Auto-placement: position app windows when they appear
--

local function findScreenByName(pattern)
  for _, screen in ipairs(hs.screen.allScreens()) do
    if (screen:name() or ''):find(pattern, 1, true) then
      return screen
    end
  end
  return nil
end

-- App rules keyed by bundle ID.
-- { screen = name pattern, position = frame function }
-- { desktop = N, position = frame function }
local AUTO_PLACE = {
  ['com.apple.reminders']        = { screen = 'Built-in', position = leftHalfFrame },
  ['com.culturedcode.ThingsMac'] = { screen = 'Built-in', position = rightHalfFrame },
  ['com.tinyspeck.slackmacgap']  = { screen = 'LG UltraFine', position = fullscreenOnlyFrame },
  -- TODO: troubleshoot desktop move for Granola
  -- ['com.granola.app']            = { desktop = 6, position = function(s)
  --   local w = 800
  --   return { x = s.x + s.w - w, y = s.y, w = w, h = s.h }
  -- end },
  ['us.zoom.xos']                = { desktop = 6, position = function(s)
    local w, h = 1200, 1000
    return { x = s.x + (s.w - w) / 2, y = s.y, w = w, h = h }
  end },
}

-- Queue for serializing desktop moves (spaces.lua's isMoving guard
-- prevents concurrent moves).
local desktopMoveQueue = {}
local isProcessingQueue = false

local function processDesktopQueue()
  if #desktopMoveQueue == 0 then
    isProcessingQueue = false
    return
  end
  isProcessingQueue = true
  local item = table.remove(desktopMoveQueue, 1)
  item.win:focus()
  hs.timer.doAfter(0.1, function()
    SPACES.moveWindowToSpace(item.desktop)
    if item.position then
      hs.timer.doAfter(0.5, function()
        item.win:setFrame(item.position(item.win:screen():frame()))
      end)
    end
    -- Wait for isMoving to clear before processing the next move
    hs.timer.doAfter(3, processDesktopQueue)
  end)
end

local function queueDesktopMove(win, rule)
  table.insert(desktopMoveQueue, {
    win = win,
    desktop = rule.desktop,
    position = rule.position,
  })
  if not isProcessingQueue then
    processDesktopQueue()
  end
end

local function applyPlacement(win, rule)
  if rule.screen then
    local target = findScreenByName(rule.screen)
    if not target then return end
    if rule.position then
      win:setFrame(rule.position(target:frame()))
    end
  elseif rule.desktop and SPACES then
    queueDesktopMove(win, rule)
  end
end

-- Retry until the app has a visible window, then apply placement.
local function waitForWindowAndPlace(app, rule, attempts)
  attempts = attempts or 0
  if attempts > 10 then return end
  if not app or not app:isRunning() then return end

  local wins = app:allWindows()
  local placed = false
  for _, win in ipairs(wins) do
    if win:isVisible() then
      applyPlacement(win, rule)
      placed = true
    end
  end

  if not placed then
    hs.timer.doAfter(1, function()
      waitForWindowAndPlace(app, rule, attempts + 1)
    end)
  end
end

local placementWatcher = hs.application.watcher.new(function(_, event, app)
  if event ~= hs.application.watcher.launched then return end
  if not app then return end

  local bundleID = app:bundleID()
  local rule = bundleID and AUTO_PLACE[bundleID]
  if not rule then return end

  waitForWindowAndPlace(app, rule, 0)
end)
placementWatcher:start()

--
-- Keybindings
--

local shiftAlt = { 'shift', 'alt' }
local ctrlShiftAlt = { 'ctrl', 'shift', 'alt' }

-- Positioning: ctrl+shift+alt
hs.hotkey.bind(ctrlShiftAlt, 'h', M.leftHalf)
hs.hotkey.bind(ctrlShiftAlt, 'l', M.rightHalf)
hs.hotkey.bind(ctrlShiftAlt, 'k', M.topHalf)
hs.hotkey.bind(ctrlShiftAlt, 'j', M.bottomHalf)
hs.hotkey.bind(ctrlShiftAlt, 'c', M.center)
-- Toggle maximize: shift+alt
hs.hotkey.bind(shiftAlt, 'f', M.maximize)
-- Swapping: shift+alt
hs.hotkey.bind(shiftAlt, 'h', M.swapLeft)
hs.hotkey.bind(shiftAlt, 'l', M.swapRight)
hs.hotkey.bind(shiftAlt, 'k', M.swapUp)
hs.hotkey.bind(shiftAlt, 'j', M.swapDown)
-- Focus: alt
local alt = { 'alt' }
hs.hotkey.bind(alt, 'h', function()
  local win = hs.window.focusedWindow()
  if win then win:focusWindowWest(nil, false, false) end
end)
hs.hotkey.bind(alt, 'l', function()
  local win = hs.window.focusedWindow()
  if win then win:focusWindowEast(nil, false, false) end
end)
hs.hotkey.bind(alt, 'k', function()
  local win = hs.window.focusedWindow()
  if win then win:focusWindowNorth(nil, false, false) end
end)
hs.hotkey.bind(alt, 'j', function()
  local win = hs.window.focusedWindow()
  if win then win:focusWindowSouth(nil, false, false) end
end)

return M
