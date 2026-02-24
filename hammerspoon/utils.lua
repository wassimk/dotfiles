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

function M.resizeForMeeting()
  local zoom = hs.application.open('zoom.us')
  local granola = hs.application.open('granola')

  -- Resize Zoom windows
  if zoom then
    local zoomWindows = zoom:allWindows()
    for _, window in ipairs(zoomWindows) do
      local screen = window:screen()
      local frame = screen:frame()

      local newWidth = 1280
      local newHeight = 1000

      local newX = frame.x + (frame.w - newWidth) / 2
      local newY = frame.y + 15

      window:setFrame({
        x = newX,
        y = newY,
        w = newWidth,
        h = newHeight,
      })
    end
  end

  -- Resize Granola windows
  if granola then
    local granolaWindows = granola:allWindows()
    for _, window in ipairs(granolaWindows) do
      local screen = window:screen()
      local frame = screen:frame()

      local newWidth = 800
      local newHeight = 1200

      local newX = frame.x + frame.w - newWidth - 15
      local newY = frame.y + 15

      window:setFrame({
        x = newX,
        y = newY,
        w = newWidth,
        h = newHeight,
      })
    end
  end
end

function M.resizeForScreencasting(appNames)
  for _, appName in ipairs(appNames) do
    local app = hs.application.find(appName)
    if app then
      local windows = app:allWindows()
      for _, window in ipairs(windows) do
        local screen = window:screen()
        local frame = screen:frame()

        local newWidth = 1280
        local newHeight = 720

        local newX = frame.x + (frame.w - newWidth) / 2
        local newY = frame.y + 25

        window:setFrame({
          x = newX,
          y = newY,
          w = newWidth,
          h = newHeight,
        })
      end
    end
  end
end

function M.stopScreencasting()
  -- No-op: AeroSpace layout restore removed. Manually reposition windows as needed.
end

function M.printRunningApps()
  local apps = hs.application.runningApplications()
  for _, app in ipairs(apps) do
    print(app:name())
  end
end

return M
