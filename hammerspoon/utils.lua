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

function M.resizeForScreencasting(appNames)
  for _, appName in ipairs(appNames) do
    local app = hs.application.find(appName)
    if app then
      local windows = app:allWindows()
      for _, window in ipairs(windows) do
        local screen = window:screen()
        local frame = screen:frame()

        local newWidth = 1920
        local newHeight = 1080

        -- Calculate the new x and y coordinates to center the window
        local newX = frame.x + (frame.w - newWidth) / 2
        local newY = frame.y + (frame.h - newHeight) / 2

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

function M.yabaiWindowIdForApp(app)
  local appPid = app:pid()
  local yabaiWindowIdCommand = 'yabai -m query --windows | jq \'.[] | select(.pid=="' .. appPid .. '") | .id\''
  local yabaiWindowId, _, _, _ = hs.execute(yabaiWindowIdCommand, true)

  return yabaiWindowId:gsub('[\n\r]', '')
end

function M.toggleYabaiWindowFloatByApp(app)
  local yabaiWindowId = M.yabaiWindowIdForApp(app)
  local yabaiDetachCommand = 'yabai -m window ' .. yabaiWindowId .. ' --toggle float'
  hs.execute(yabaiDetachCommand, true)
end

function M.printRunningApps()
  local apps = hs.application.runningApplications()
  for _, app in ipairs(apps) do
    print(app:name())
  end
end

return M
