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

-- Saved frames for toggle restore (keyed by window ID)
local preMaximizeFrames = {}
local preCenterFrames = {}

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

-- Minimum size for a window to be considered a real neighbor
local MIN_SWAP_SIZE = 200

-- Find the nearest real window on the same screen in a given direction.
local function findNeighbor(win, directionFn)
  local neighbors = directionFn(win)
  if not neighbors then return nil end
  local winScreen = win:screen():id()
  for _, n in ipairs(neighbors) do
    local nf = n:frame()
    if n:screen():id() == winScreen
      and n:isStandard()
      and nf.w >= MIN_SWAP_SIZE
      and nf.h >= MIN_SWAP_SIZE then
      return n
    end
  end
  return nil
end

local function leftHalfFrame(s)
  local w = (s.w - GAP) / 2
  return { x = s.x, y = s.y, w = w, h = s.h }
end

local function rightHalfFrame(s)
  local w = (s.w - GAP) / 2
  return { x = s.x + w + GAP, y = s.y, w = w, h = s.h }
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

  local screen = win:screen()
  if isFullscreenOnly(screen) then
    win:setFrame(fullscreenOnlyFrame(screen:frame()))
    return
  end

  local s = screen:frame()
  local w = s.w * 0.70
  local centerFrame = {
    x = s.x + (s.w - w) / 2,
    y = s.y,
    w = w,
    h = s.h,
  }

  if framesMatch(win:frame(), centerFrame) then
    local saved = preCenterFrames[win:id()]
    if saved then
      win:setFrame(saved)
      preCenterFrames[win:id()] = nil
    else
      win:setFrame(leftHalfFrame(s))
    end
  else
    preCenterFrames[win:id()] = win:frame()
    win:setFrame(centerFrame)
  end
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
-- Moving and Swapping
--

-- Find the nearest real window on a specific screen.
local function findWindowOnScreen(excludeWin, targetScreen)
  local targetId = targetScreen:id()
  local excludeId = excludeWin:id()
  for _, w in ipairs(hs.window.visibleWindows()) do
    if w:id() ~= excludeId
      and w:screen():id() == targetId
      and w:isStandard()
      and w:frame().w >= MIN_SWAP_SIZE
      and w:frame().h >= MIN_SWAP_SIZE then
      return w
    end
  end
  return nil
end

-- Check if a target frame is occupied by another window on the same screen.
local function findWindowAtFrame(excludeWin, screen, targetFrame)
  local screenId = screen:id()
  local excludeId = excludeWin:id()
  for _, w in ipairs(hs.window.visibleWindows()) do
    if w:id() ~= excludeId
      and w:screen():id() == screenId
      and w:isStandard()
      and w:frame().w >= MIN_SWAP_SIZE
      and w:frame().h >= MIN_SWAP_SIZE
      and framesMatch(w:frame(), targetFrame) then
      return w
    end
  end
  return nil
end

-- Swap: prefer moving into empty space, only swap if the target is occupied.
-- At screen edge, cross to next monitor with the same logic.
function M.swapLeft()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()
  local s = screen:frame()
  local atEdge = math.abs(win:frame().x - s.x) < TOLERANCE

  if not atEdge then
    -- Target is left half of current screen
    local target = leftHalfFrame(s)
    local occupant = findWindowAtFrame(win, screen, target)
    if occupant then
      local wf = { x = win:frame().x, y = win:frame().y, w = win:frame().w, h = win:frame().h }
      win:setFrame(target)
      occupant:setFrame(wf)
    else
      win:setFrame(target)
    end
  else
    -- At left edge, cross to next monitor
    local next = screen:toWest()
    if not next then return end
    if isFullscreenOnly(next) then
      local target = fullscreenOnlyFrame(next:frame())
      local occupant = findWindowOnScreen(win, next)
      if occupant then
        local wf = { x = win:frame().x, y = win:frame().y, w = win:frame().w, h = win:frame().h }
        win:setFrame(target)
        occupant:setFrame(wf)
      else
        win:setFrame(target)
      end
    else
      local target = rightHalfFrame(next:frame())
      local occupant = findWindowAtFrame(win, next, target)
      if occupant then
        local wf = { x = win:frame().x, y = win:frame().y, w = win:frame().w, h = win:frame().h }
        win:setFrame(target)
        occupant:setFrame(wf)
      else
        win:setFrame(target)
      end
    end
  end
end

function M.swapRight()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()
  local s = screen:frame()
  local f = win:frame()
  local atEdge = math.abs((f.x + f.w) - (s.x + s.w)) < TOLERANCE

  if not atEdge then
    -- Target is right half of current screen
    local target = rightHalfFrame(s)
    local occupant = findWindowAtFrame(win, screen, target)
    if occupant then
      local wf = { x = f.x, y = f.y, w = f.w, h = f.h }
      win:setFrame(target)
      occupant:setFrame(wf)
    else
      win:setFrame(target)
    end
  else
    -- At right edge, cross to next monitor
    local next = screen:toEast()
    if not next then return end
    if isFullscreenOnly(next) then
      local target = fullscreenOnlyFrame(next:frame())
      local occupant = findWindowOnScreen(win, next)
      if occupant then
        local wf = { x = f.x, y = f.y, w = f.w, h = f.h }
        win:setFrame(target)
        occupant:setFrame(wf)
      else
        win:setFrame(target)
      end
    else
      local target = leftHalfFrame(next:frame())
      local occupant = findWindowAtFrame(win, next, target)
      if occupant then
        local wf = { x = f.x, y = f.y, w = f.w, h = f.h }
        win:setFrame(target)
        occupant:setFrame(wf)
      else
        win:setFrame(target)
      end
    end
  end
end

-- Move window to a half. Crosses to the next monitor if already at the edge.
function M.moveLeft()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()

  if isFullscreenOnly(screen) then
    local next = screen:toWest()
    if next then
      local apply = isFullscreenOnly(next) and fullscreenOnlyFrame or rightHalfFrame
      win:setFrame(apply(next:frame()))
    end
    return
  end

  local s = screen:frame()
  local target = leftHalfFrame(s)

  if framesMatch(win:frame(), target) then
    -- Already at left half, cross to next monitor
    local next = screen:toWest()
    if next then
      if isFullscreenOnly(next) then
        win:setFrame(fullscreenOnlyFrame(next:frame()))
      else
        win:setFrame(rightHalfFrame(next:frame()))
      end
    end
  else
    win:setFrame(target)
  end
end

function M.moveRight()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()

  if isFullscreenOnly(screen) then
    local next = screen:toEast()
    if next then
      local apply = isFullscreenOnly(next) and fullscreenOnlyFrame or leftHalfFrame
      win:setFrame(apply(next:frame()))
    end
    return
  end

  local s = screen:frame()
  local target = rightHalfFrame(s)

  if framesMatch(win:frame(), target) then
    -- Already at right half, cross to next monitor
    local next = screen:toEast()
    if next then
      if isFullscreenOnly(next) then
        win:setFrame(fullscreenOnlyFrame(next:frame()))
      else
        win:setFrame(leftHalfFrame(next:frame()))
      end
    end
  else
    win:setFrame(target)
  end
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
-- Resizing
--

local RESIZE_STEP = 0.05 -- 5% of screen size per keypress

-- Determine which edges are snapped to the screen boundary.
local function isSnappedLeft(f, s)
  return math.abs(f.x - s.x) < TOLERANCE
end

local function isSnappedRight(f, s)
  return math.abs((f.x + f.w) - (s.x + s.w)) < TOLERANCE
end

-- After resizing, adjust the neighbor window to follow the shared edge.
local function adjustNeighbor(win, side)
  local neighbor
  local wf = win:frame()

  if side == 'right' then
    neighbor = findNeighbor(win, function(w) return w:windowsToEast(nil, false, false) end)
    if not neighbor then return end
    local nf = neighbor:frame()
    local newX = wf.x + wf.w + GAP
    neighbor:setFrame({ x = newX, y = nf.y, w = nf.w + (nf.x - newX), h = nf.h })
  elseif side == 'left' then
    neighbor = findNeighbor(win, function(w) return w:windowsToWest(nil, false, false) end)
    if not neighbor then return end
    local nf = neighbor:frame()
    local newW = (wf.x - GAP) - nf.x
    neighbor:setFrame({ x = nf.x, y = nf.y, w = newW, h = nf.h })
  end
end

-- Resize a floating window evenly from both sides, clamped to screen edges.
-- Floating windows don't push neighbors — they sit on top.
local function resizeFloatGrow(win, step)
  local s = win:screen():frame()
  local f = win:frame()
  local half = step / 2
  local newX = math.max(f.x - half, s.x)
  local newW = math.min(f.w + (f.x - newX) + half, s.x + s.w - newX)
  win:setFrame({ x = newX, y = f.y, w = newW, h = f.h })
end

local function resizeFloatShrink(win, step)
  local s = win:screen():frame()
  local f = win:frame()
  local half = step / 2
  local newW = math.max(f.w - step, s.w * 0.1)
  local shrunk = f.w - newW
  local newX = f.x + shrunk / 2
  win:setFrame({ x = newX, y = f.y, w = newW, h = f.h })
end

-- Arrow direction = direction the active edge moves.
-- Snapped to left edge: right edge is active. Snapped to right: left edge is active.
-- Floating (neither snapped): right grows evenly, left shrinks evenly. No neighbor pushing.
-- Adjacent windows on the resized side follow the edge (snapped only).
function M.resizeLeft()
  local win = hs.window.focusedWindow()
  if not win then return end
  local s = win:screen():frame()
  local f = win:frame()
  local step = s.w * RESIZE_STEP

  if not isSnappedLeft(f, s) and not isSnappedRight(f, s) then
    resizeFloatShrink(win, step)
  elseif isSnappedLeft(f, s) then
    -- shrink: right edge moves left
    local newW = math.max(f.w - step, s.w * 0.1)
    win:setFrame({ x = f.x, y = f.y, w = newW, h = f.h })
    adjustNeighbor(win, 'right')
  else
    -- expand: left edge moves left
    local newX = math.max(f.x - step, s.x)
    win:setFrame({ x = newX, y = f.y, w = f.w + (f.x - newX), h = f.h })
    adjustNeighbor(win, 'left')
  end
end

function M.resizeRight()
  local win = hs.window.focusedWindow()
  if not win then return end
  local s = win:screen():frame()
  local f = win:frame()
  local step = s.w * RESIZE_STEP

  if not isSnappedLeft(f, s) and not isSnappedRight(f, s) then
    resizeFloatGrow(win, step)
  elseif isSnappedRight(f, s) then
    -- shrink: left edge moves right
    local newW = math.max(f.w - step, s.w * 0.1)
    local newX = f.x + (f.w - newW)
    win:setFrame({ x = newX, y = f.y, w = newW, h = f.h })
    adjustNeighbor(win, 'left')
  else
    -- expand: right edge moves right
    local newW = math.min(f.w + step, s.x + s.w - f.x)
    win:setFrame({ x = f.x, y = f.y, w = newW, h = f.h })
    adjustNeighbor(win, 'right')
  end
end

function M.resizeTaller()
  local win = hs.window.focusedWindow()
  if not win then return end
  local s = win:screen():frame()
  local f = win:frame()
  local step = s.h * RESIZE_STEP
  local halfStep = step / 2
  local newY = math.max(f.y - halfStep, s.y)
  local newH = math.min(f.h + step, s.h)
  -- clamp bottom edge to screen
  if newY + newH > s.y + s.h then newH = s.y + s.h - newY end
  win:setFrame({ x = f.x, y = newY, w = f.w, h = newH })
end

function M.resizeShorter()
  local win = hs.window.focusedWindow()
  if not win then return end
  local s = win:screen():frame()
  local f = win:frame()
  local step = s.h * RESIZE_STEP
  local minH = s.h * 0.1
  local halfStep = step / 2
  local newH = math.max(f.h - step, minH)
  local newY = f.y + halfStep
  -- clamp top edge to screen
  if newY < s.y then newY = s.y end
  if newY + newH > s.y + s.h then newH = s.y + s.h - newY end
  win:setFrame({ x = f.x, y = newY, w = f.w, h = newH })
end

-- Normalize all visible windows on the current screen to equal widths.
function M.normalize()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()
  local screenId = screen:id()
  local s = screen:frame()

  local wins = {}
  for _, w in ipairs(hs.window.visibleWindows()) do
    if w:screen():id() == screenId
      and w:isStandard()
      and w:frame().w >= MIN_SWAP_SIZE
      and w:frame().h >= MIN_SWAP_SIZE then
      table.insert(wins, w)
    end
  end

  if #wins < 2 then return end

  table.sort(wins, function(a, b) return a:frame().x < b:frame().x end)

  local totalGap = GAP * (#wins - 1)
  local sliceW = (s.w - totalGap) / #wins
  for i, w in ipairs(wins) do
    local x = s.x + (i - 1) * (sliceW + GAP)
    w:setFrame({ x = x, y = s.y, w = sliceW, h = s.h })
  end
end

--
-- Keybindings
--

local shiftAlt = { 'shift', 'alt' }
local ctrlShiftAlt = { 'ctrl', 'shift', 'alt' }

-- Moving: ctrl+shift+alt
hs.hotkey.bind(ctrlShiftAlt, 'h', M.moveLeft)
hs.hotkey.bind(ctrlShiftAlt, 'l', M.moveRight)
-- Swapping: shift+alt
hs.hotkey.bind(shiftAlt, 'h', M.swapLeft)
hs.hotkey.bind(shiftAlt, 'l', M.swapRight)
-- Toggle maximize / center: shift+alt
hs.hotkey.bind(shiftAlt, 't', M.maximize)
hs.hotkey.bind(shiftAlt, 'c', M.center)
-- Resizing: shift+alt
hs.hotkey.bind(shiftAlt, 'left', M.resizeLeft)
hs.hotkey.bind(shiftAlt, 'right', M.resizeRight)
hs.hotkey.bind(shiftAlt, 'up', M.resizeTaller)
hs.hotkey.bind(shiftAlt, 'down', M.resizeShorter)
hs.hotkey.bind(shiftAlt, '0', M.normalize)
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
