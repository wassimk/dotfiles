-- Forward function declarations.
local reload = nil
local reloadFiles = nil

reloadFiles = function(files)
  local shouldReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      shouldReload = true
    end
  end
  if shouldReload then
    reload()
  end
end

reload = function()
  hs.reload()
end

return {
  init = function()
    local watcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.dotfiles/hammerspoon/', reloadFiles)
    watcher:start()
  end,
  reload = reload,
}
