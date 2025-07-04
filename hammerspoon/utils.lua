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
  local aerospaceWorkspaceId = 8
  hs.execute('aerospace summon-workspace ' .. aerospaceWorkspaceId, true)
  local zoom = hs.application.open('zoom.us')
  local granola = hs.application.open('granola')

  -- Move apps to workspace
  local apps = { zoom, granola }
  for _, app in ipairs(apps) do
    if app then
      local windows = app:allWindows()
      for _, window in ipairs(windows) do
        local windowId = window:id()
        hs.execute('aerospace move-node-to-workspace ' .. aerospaceWorkspaceId .. ' --window-id ' .. windowId, true)
      end
    end
  end

  -- Float all windows in workspace
  M.toggleFloatOfAerospaceWorkspaceWindows(aerospaceWorkspaceId)

  -- Resize Zoom windows
  local zoomWindows = zoom:allWindows()
  for _, window in ipairs(zoomWindows) do
    local screen = window:screen()
    local frame = screen:frame()

    local newWidth = 1280
    local newHeight = 720

    -- Position zoom window at the top center of the screen
    local newX = frame.x + (frame.w - newWidth) / 2
    local newY = frame.y + 15 -- Position at top with small margin

    window:setFrame({
      x = newX,
      y = newY,
      w = newWidth,
      h = newHeight,
    })
  end

  -- Resize Granola windows
  local granolaWindows = granola:allWindows()
  for _, window in ipairs(granolaWindows) do
    local screen = window:screen()
    local frame = screen:frame()

    local newWidth = 800
    local newHeight = 1200

    -- Position on top of and to the right of zoom window for notes
    local newX = frame.x + frame.w - newWidth - 225
    local newY = frame.y + 15 -- Position at top with small margin

    window:setFrame({
      x = newX,
      y = newY,
      w = newWidth,
      h = newHeight,
    })
  end
end

function M.resizeForScreencasting(appNames)
  local aerospaceWorkspaceId = 1
  hs.execute('aerospace summon-workspace ' .. aerospaceWorkspaceId, true)

  -- Move all specified apps to workspace
  for _, appName in ipairs(appNames) do
    local app = hs.application.find(appName)
    if app then
      local windows = app:allWindows()
      for _, window in ipairs(windows) do
        -- Move window to workspace
        local windowId = window:id()
        hs.execute('aerospace move-node-to-workspace ' .. aerospaceWorkspaceId .. ' --window-id ' .. windowId, true)
      end
    end
  end

  -- Float all windows in workspace
  M.toggleFloatOfAerospaceWorkspaceWindows(aerospaceWorkspaceId)

  -- Resize all specified apps
  for _, appName in ipairs(appNames) do
    local app = hs.application.find(appName)
    if app then
      local windows = app:allWindows()
      for _, window in ipairs(windows) do
        local screen = window:screen()
        local frame = screen:frame()

        local newWidth = 1280
        local newHeight = 720

        -- Calculate the new x and y coordinates to center horizontally and position at top
        local newX = frame.x + (frame.w - newWidth) / 2
        local newY = frame.y + 25 -- Position at top with small margin

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

function M.toggleFloatOfAerospaceWorkspaceWindows(workspaceId)
  workspaceId = workspaceId or 'focused'
  local aerospaceWindowsCommand = 'aerospace list-windows --workspace ' .. workspaceId .. ' --json'
  local aerospaceWindowsOutput, status, _, _ = hs.execute(aerospaceWindowsCommand, true)

  if status then
    local windows = hs.json.decode(aerospaceWindowsOutput)
    for _, window in ipairs(windows) do
      local windowId = window['window-id']
      local floatCommand = 'aerospace layout floating --window-id ' .. windowId
      hs.execute(floatCommand, true)
    end
  end
end

function M.promptScreencastAction(appNames)
  local chooser = hs.chooser.new(function(choice)
    if choice then
      if choice.action == 'on' then
        hs.notify.new({ title = 'Screencast', informativeText = 'Starting screencast mode' }):send()
        M.resizeForScreencasting(appNames)
      elseif choice.action == 'off' then
        hs.notify.new({ title = 'Screencast', informativeText = 'Stopping screencast mode' }):send()
        M.stopScreencasting()
      end
    end
  end)

  chooser:choices({
    { text = 'Start Screencasting', action = 'on' },
    { text = 'Stop Screencasting', action = 'off' },
  })

  chooser:show()
end

function M.stopScreencasting()
  local aerospaceWorkspaceId = 1
  hs.execute('aerospace summon-workspace ' .. aerospaceWorkspaceId, true)

  -- Set all windows back to accordion layout
  M.setAccordionLayoutForWorkspace(aerospaceWorkspaceId)
end

function M.setAccordionLayoutForWorkspace(workspaceId)
  workspaceId = workspaceId or 'focused'
  local aerospaceWindowsCommand = 'aerospace list-windows --workspace ' .. workspaceId .. ' --json'
  local aerospaceWindowsOutput, status, _, _ = hs.execute(aerospaceWindowsCommand, true)

  if status then
    local windows = hs.json.decode(aerospaceWindowsOutput)
    for _, window in ipairs(windows) do
      local windowId = window['window-id']
      local accordionCommand = 'aerospace layout tiling --window-id ' .. windowId
      hs.execute(accordionCommand, true)
    end
  end
end

function M.printRunningApps()
  local apps = hs.application.runningApplications()
  for _, app in ipairs(apps) do
    print(app:name())
  end
end

return M
