--
-- cheatsheet.lua - Hold-to-show modifier cheatsheet popups
--

local M = {}

local registrations = {}

-- Colors
local BG_COLOR = { red = 0.12, green = 0.12, blue = 0.14, alpha = 0.95 }
local TITLE_COLOR = { red = 0.95, green = 0.95, blue = 0.95, alpha = 1 }
local SECTION_COLOR = { red = 0.7, green = 0.7, blue = 0.7, alpha = 1 }
local LABEL_COLOR = { red = 0.88, green = 0.88, blue = 0.88, alpha = 1 }
local BADGE_BG = { red = 0.22, green = 0.2, blue = 0.16, alpha = 1 }
local BADGE_TEXT = { red = 0.92, green = 0.78, blue = 0.32, alpha = 1 }
local SEPARATOR_COLOR = { red = 0.3, green = 0.3, blue = 0.3, alpha = 0.6 }

-- Layout
local PADDING = 32
local TITLE_SIZE = 22
local SECTION_SIZE = 13
local LABEL_SIZE = 14
local BADGE_SIZE = 14
local ROW_HEIGHT = 28
local BADGE_W = 26
local BADGE_H = 22
local COL_WIDTH = 240
local COL_GAP = 24
local CORNER_RADIUS = 14

-- Check if the currently held modifiers exactly match the target set
-- (no extra standard modifiers allowed).
local STANDARD_FLAGS = { 'cmd', 'ctrl', 'alt', 'shift' }

local function flagsMatchTarget(flags, target)
  for _, mod in ipairs(STANDARD_FLAGS) do
    local want = false
    for _, t in ipairs(target) do
      if t == mod then want = true; break end
    end
    if want ~= (flags[mod] or false) then return false end
  end
  return true
end

local function buildCanvas(reg)
  local sections = reg.sections
  local numCols = #sections

  -- Compute canvas height from tallest column
  local maxRows = 0
  for _, sec in ipairs(sections) do
    -- section title + bindings + subsection titles
    local rows = 1 -- section title
    for _, item in ipairs(sec.items) do
      if item.separator then
        rows = rows + 1.2 -- subsection header
      else
        rows = rows + 1
      end
    end
    if rows > maxRows then maxRows = rows end
  end

  local contentH = TITLE_SIZE + 20 + (maxRows * ROW_HEIGHT) + PADDING
  local canvasW = (numCols * COL_WIDTH) + ((numCols - 1) * COL_GAP) + (PADDING * 2)
  local canvasH = contentH + PADDING

  local screen = hs.screen.mainScreen()
  local sf = screen:frame()
  local x = sf.x + (sf.w - canvasW) / 2
  local y = sf.y + (sf.h - canvasH) / 2

  local c = hs.canvas.new({ x = x, y = y, w = canvasW, h = canvasH })
  c:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
  c:level(hs.canvas.windowLevels.overlay)

  -- Background
  c:appendElements({
    type = 'rectangle',
    frame = { x = 0, y = 0, w = canvasW, h = canvasH },
    roundedRectRadii = { xRadius = CORNER_RADIUS, yRadius = CORNER_RADIUS },
    fillColor = BG_COLOR,
    strokeColor = { red = 0.3, green = 0.3, blue = 0.3, alpha = 0.5 },
    strokeWidth = 1,
  })

  -- Title
  c:appendElements({
    type = 'text',
    frame = { x = PADDING, y = PADDING - 4, w = canvasW - PADDING * 2, h = TITLE_SIZE + 8 },
    text = hs.styledtext.new(reg.title, {
      font = { name = '.AppleSystemUIFontBold', size = TITLE_SIZE },
      color = TITLE_COLOR,
      paragraphStyle = { alignment = 'center' },
    }),
  })

  local startY = PADDING + TITLE_SIZE + 20

  for colIdx, sec in ipairs(sections) do
    local colX = PADDING + (colIdx - 1) * (COL_WIDTH + COL_GAP)
    local curY = startY

    -- Column separator line (before columns 2+)
    if colIdx > 1 then
      local sepX = colX - COL_GAP / 2
      c:appendElements({
        type = 'rectangle',
        frame = { x = sepX, y = startY, w = 1, h = canvasH - startY - PADDING },
        fillColor = SEPARATOR_COLOR,
      })
    end

    -- Section title
    c:appendElements({
      type = 'text',
      frame = { x = colX, y = curY, w = COL_WIDTH, h = SECTION_SIZE + 6 },
      text = hs.styledtext.new(sec.title:upper(), {
        font = { name = '.AppleSystemUIFontBold', size = SECTION_SIZE },
        color = SECTION_COLOR,
      }),
    })
    curY = curY + ROW_HEIGHT

    for _, item in ipairs(sec.items) do
      if item.separator then
        -- Subsection header
        curY = curY + 6
        c:appendElements({
          type = 'text',
          frame = { x = colX, y = curY, w = COL_WIDTH, h = SECTION_SIZE + 6 },
          text = hs.styledtext.new(item.separator:upper(), {
            font = { name = '.AppleSystemUIFontBold', size = SECTION_SIZE },
            color = SECTION_COLOR,
          }),
        })
        curY = curY + ROW_HEIGHT - 6
      else
        -- Key badge
        local badgeX = colX
        local badgeY = curY + (ROW_HEIGHT - BADGE_H) / 2
        c:appendElements({
          type = 'rectangle',
          frame = { x = badgeX, y = badgeY, w = BADGE_W, h = BADGE_H },
          roundedRectRadii = { xRadius = 5, yRadius = 5 },
          fillColor = BADGE_BG,
        })
        c:appendElements({
          type = 'text',
          frame = { x = badgeX, y = badgeY, w = BADGE_W, h = BADGE_H },
          text = hs.styledtext.new(item.key:upper(), {
            font = { name = 'MonoLisa', size = BADGE_SIZE },
            color = BADGE_TEXT,
            paragraphStyle = { alignment = 'center' },
          }),
        })

        -- Label
        c:appendElements({
          type = 'text',
          frame = { x = colX + BADGE_W + 10, y = curY + 3, w = COL_WIDTH - BADGE_W - 10, h = LABEL_SIZE + 6 },
          text = hs.styledtext.new(item.label, {
            font = { name = '.AppleSystemUIFont', size = LABEL_SIZE },
            color = LABEL_COLOR,
          }),
        })

        curY = curY + ROW_HEIGHT
      end
    end
  end

  return c
end

function M.register(name, opts)
  registrations[name] = {
    modifiers = opts.modifiers,
    holdTime = opts.holdTime or 1.0,
    title = opts.title or name,
    sections = opts.sections,
    canvas = nil,
    holdTimer = nil,
    keyWatcher = nil,
  }
end

function M.start()
  local flagsTap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)
    local flags = e:getFlags()
    for _, reg in pairs(registrations) do
      if flagsMatchTarget(flags, reg.modifiers) then
        -- Modifiers match: start hold timer if not already running
        if not reg.holdTimer then
          -- Install a temporary keyDown watcher to cancel on any key press
          reg.keyWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function()
            if reg.holdTimer then
              reg.holdTimer:stop()
              reg.holdTimer = nil
            end
            if reg.keyWatcher then
              reg.keyWatcher:stop()
              reg.keyWatcher = nil
            end
            return false
          end)
          reg.keyWatcher:start()

          reg.holdTimer = hs.timer.doAfter(reg.holdTime, function()
            reg.holdTimer = nil
            if reg.keyWatcher then
              reg.keyWatcher:stop()
              reg.keyWatcher = nil
            end
            -- Only show if modifiers are still held
            local currentFlags = hs.eventtap.checkKeyboardModifiers()
            if flagsMatchTarget(currentFlags, reg.modifiers) then
              if not reg.canvas then
                reg.canvas = buildCanvas(reg)
              end
              reg.canvas:show()
            end
          end)
        end
      else
        -- Modifiers no longer match: cancel timer and hide popup
        if reg.holdTimer then
          reg.holdTimer:stop()
          reg.holdTimer = nil
        end
        if reg.keyWatcher then
          reg.keyWatcher:stop()
          reg.keyWatcher = nil
        end
        if reg.canvas then
          reg.canvas:hide()
        end
      end
    end
    return false
  end)
  flagsTap:start()
end

return M
