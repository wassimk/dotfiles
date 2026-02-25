--
-- spaces.lua - Move windows between macOS desktops (spaces)
--
-- Since hs.spaces.moveWindowToSpace() is broken on modern macOS, this uses a
-- workaround: simulate grabbing the window title bar, performing a small drag
-- to establish drag state, then triggering the desktop switch keyboard shortcut.
--
-- Prerequisite: System Settings > Keyboard > Keyboard Shortcuts > Mission Control
-- must have "Switch to Desktop N" shortcuts enabled (ctrl+1, ctrl+2, etc.)
--

local M = {}

-- Click at the very top edge of the window to hit the macOS window frame
-- drag zone (the resize/double-arrow zone). This works universally for all
-- apps, including those with hidden title bars or tabs in the title bar.
local MOUSE_OFFSET_Y = 1
local DRAG_DISTANCE = 10
local RELEASE_DELAY = 0.3
local SAFETY_TIMEOUT = 2.0

local isMoving = false
local movingTimeout = nil

local function resetMovingState()
  if movingTimeout then
    movingTimeout:stop()
    movingTimeout = nil
  end
  isMoving = false
end

local function startMovingState()
  isMoving = true
  if movingTimeout then
    movingTimeout:stop()
  end
  movingTimeout = hs.timer.doAfter(SAFETY_TIMEOUT, function()
    if isMoving then
      LOG.wf("spaces: safety timeout, resetting isMoving")
      isMoving = false
    end
    movingTimeout = nil
  end)
end

-- Guard against the Finder desktop pseudo-window (covers the whole screen)
local function isFinderDesktop(win)
  local app = win:application()
  local bundleID = app and app:bundleID()
  if bundleID ~= "com.apple.finder" then return false end
  local screenFrame = win:screen():frame()
  local winFrame = win:frame()
  return winFrame.w > screenFrame.w and winFrame.h > screenFrame.h
end

-- Core move sequence: grab window frame edge, drag to establish grab, switch desktop, release
local function performMove(win, keyModifiers, keyName, callback)
  local frame = win:frame()
  local originalFrame = { x = frame.x, y = frame.y, w = frame.w, h = frame.h }

  local clickPos = hs.geometry.point(frame.x + frame.w / 2, frame.y + MOUSE_OFFSET_Y)
  local originalMouse = hs.mouse.absolutePosition()

  -- Step 1: Move mouse to title bar
  hs.mouse.absolutePosition(clickPos)

  hs.timer.doAfter(0.05, function()
    -- Step 2: Mouse down at top edge of window
    hs.eventtap.event.newMouseEvent(
      hs.eventtap.event.types.leftMouseDown, clickPos
    ):post()

    hs.timer.doAfter(0.15, function()
      -- Step 3: Drag to establish drag state. Multiple small drag events
      -- cross macOS's drag threshold from the window frame zone.
      for i = 1, DRAG_DISTANCE do
        local dragPos = hs.geometry.point(clickPos.x + i, clickPos.y)
        hs.eventtap.event.newMouseEvent(
          hs.eventtap.event.types.leftMouseDragged, dragPos
        ):setProperty(hs.eventtap.event.properties.mouseEventDeltaX, 1)
         :post()
      end

      hs.timer.doAfter(0.1, function()
        -- Step 4: Trigger desktop switch via keyboard shortcut
        hs.timer.doAfter(0, function()
          hs.eventtap.event.newKeyEvent(keyModifiers, keyName, true):post()
          hs.timer.doAfter(0.02, function()
            hs.eventtap.event.newKeyEvent(keyModifiers, keyName, false):post()

            -- Step 5: Wait for desktop animation, then release mouse and restore
            hs.timer.doAfter(RELEASE_DELAY, function()
              local finalPos = hs.mouse.absolutePosition()
              hs.eventtap.event.newMouseEvent(
                hs.eventtap.event.types.leftMouseUp, finalPos
              ):post()

              hs.timer.doAfter(0.01, function()
                if win:isVisible() then
                  win:setFrame(originalFrame)
                end
                win:raise()
                win:focus()
                hs.mouse.absolutePosition(originalMouse)
                hs.timer.doAfter(0.1, function()
                  resetMovingState()
                  if callback then callback() end
                end)
              end)
            end)
          end)
        end)
      end)
    end)
  end)
end

--- Move the focused window to a specific desktop number.
--- Requires "Switch to Desktop N" shortcuts (ctrl+N) enabled in System Settings.
---@param spaceNumber number Desktop number (1-9)
function M.moveWindowToSpace(spaceNumber)
  if isMoving then return end

  local win = hs.window.focusedWindow()
  if not win then
    hs.alert.show("No focused window")
    return
  end

  if isFinderDesktop(win) then return end

  startMovingState()
  win:raise()

  performMove(win, {"alt"}, tostring(spaceNumber))
end

--- Move the focused window one desktop to the right.
--- Requires "Move right a space" shortcut (ctrl+right) enabled in System Settings.
function M.moveWindowRight()
  if isMoving then return end

  local win = hs.window.focusedWindow()
  if not win then
    hs.alert.show("No focused window")
    return
  end

  if isFinderDesktop(win) then return end

  startMovingState()
  win:raise()

  performMove(win, {"ctrl"}, "right")
end

--- Move the focused window one desktop to the left.
--- Requires "Move left a space" shortcut (ctrl+left) enabled in System Settings.
function M.moveWindowLeft()
  if isMoving then return end

  local win = hs.window.focusedWindow()
  if not win then
    hs.alert.show("No focused window")
    return
  end

  if isFinderDesktop(win) then return end

  startMovingState()
  win:raise()

  performMove(win, {"ctrl"}, "left")
end

return M
