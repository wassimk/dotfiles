local reloadTimer = nil

local function reload()
  hs.reload()
end

local function reloadFiles(files)
  local shouldReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      shouldReload = true
    end
  end
  if shouldReload then
    if reloadTimer then reloadTimer:stop() end
    reloadTimer = hs.timer.doAfter(0.5, reload)
  end
end

local watcher = nil

return {
  init = function()
    watcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.dotfiles/hammerspoon/', reloadFiles)
    watcher:start()
  end,
  reload = reload,
}
