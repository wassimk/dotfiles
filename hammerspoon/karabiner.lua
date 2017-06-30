--
-- Until Karabiner-Elements gets the ability to target specific devices, this
-- module does auto-switching of profiles based on what's plugged in.
--

local events = require 'events'
local log = require 'log'

local handleEvent = nil
local reload = nil
local selectProfile = nil
local watcher = nil

handleEvent = (function(event)
  if event.vendorID == 1118 and event.productID == 219 then
    if event.eventType == 'added' then
      log.i('Microsoft Natural Ergonomic 4000 keyboard added')
      selectProfile('Microsoft_Natural_Ergonomic_4000')
    else
      log.i('Internal Apple keyboard added')
      selectProfile('Internal_Apple_Keyboard')
    end
  end
end)

reload = (function()
  watcher:stop()
  watcher = nil
end)

selectProfile = (function(profile)
  hs.execute(
    '/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli ' ..
    '--select-profile ' ..
    '"' .. profile .. '"'
  )
end)

events.subscribe('reload', reload)

return {
  init = (function()
    watcher = hs.usb.watcher.new(handleEvent)
    watcher:start()
  end),
}
