--
-- dim
--
-- Dim unfocused windows by giving them a highlight namespace holding a
-- desaturated, darkened copy of every global highlight group. Replaces
-- tint.nvim (archived) using only public APIs.
--
-- The namespace is rebuilt after colorscheme changes and after lazy.nvim loads
-- a plugin, so groups defined late (dap-ui, gitsigns, ...) get dimmed too
-- instead of falling back to their undimmed global definition.
--

local M = {}

local defaults = {
  -- added to each rgb channel after desaturating, negative darkens
  tint = -40,
  -- 1 keeps the original saturation, 0 is grayscale
  saturation = 0.7,
  -- lua patterns for groups that stay undimmed
  ignore_groups = {},
}

local config = vim.deepcopy(defaults)
local ns = vim.api.nvim_create_namespace('w_dim')
local enabled = true
local dirty = true
local focused = true

-- highlight keys that carry over to the dimmed copy, everything else
-- (cterm, default, link, ...) is dropped
local hl_keys = {
  'fg',
  'bg',
  'sp',
  'blend',
  'bold',
  'italic',
  'underline',
  'undercurl',
  'underdouble',
  'underdotted',
  'underdashed',
  'strikethrough',
  'reverse',
  'standout',
  'nocombine',
}

local function clamp(c)
  return math.min(math.max(math.floor(c), 0), 255)
end

--- Desaturate toward rec601 luma, then shift every channel by `tint`.
---@param color integer 24-bit rgb
---@return integer
function M.transform(color)
  local r = math.floor(color / 0x10000)
  local g = math.floor(color / 0x100) % 0x100
  local b = color % 0x100

  local luma = 0.299 * r + 0.587 * g + 0.114 * b
  local s = config.saturation
  r = clamp(r * s + luma * (1 - s) + config.tint)
  g = clamp(g * s + luma * (1 - s) + config.tint)
  b = clamp(b * s + luma * (1 - s) + config.tint)

  return r * 0x10000 + g * 0x100 + b
end

local function ignored(name)
  for _, pattern in ipairs(config.ignore_groups) do
    if name:find(pattern) then
      return true
    end
  end
  return false
end

local function build()
  for name in pairs(vim.api.nvim_get_hl(0, {})) do
    if not ignored(name) then
      -- resolve links so linked groups dim their target's colors
      local resolved = vim.api.nvim_get_hl(0, { name = name, link = false })
      local def = {}
      for _, key in ipairs(hl_keys) do
        def[key] = resolved[key]
      end
      if def.fg then
        def.fg = M.transform(def.fg)
      end
      if def.sp then
        def.sp = M.transform(def.sp)
      end
      vim.api.nvim_set_hl(ns, name, def)
    end
  end
  dirty = false
end

local function should_dim(win)
  if vim.api.nvim_win_get_config(win).relative ~= '' then
    return false -- floats: pickers, previews, notifications
  end
  -- leave windows alone when another plugin gave them their own namespace,
  -- -1 means none was ever set
  local current = vim.api.nvim_get_hl_ns({ winid = win })
  return current == -1 or current == 0 or current == ns
end

local function set_ns(win, target)
  if vim.api.nvim_get_hl_ns({ winid = win }) ~= target then
    vim.api.nvim_win_set_hl_ns(win, target)
  end
end

--- Dim every window in the current tabpage except the focused one. Covering
--- all windows, not just the one being left, catches windows opened without
--- entering them (dap-ui panels, neotest output).
function M.refresh()
  if not enabled then
    return
  end
  if dirty then
    build()
  end

  -- floats never take focus from the window behind them. nvim_open_win makes
  -- the new float current while WinNew and BufWinEnter run, even when the
  -- caller doesn't enter it, so completion menus would otherwise dim the
  -- window being typed in
  local current = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(current).relative ~= '' then
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if should_dim(win) then
      set_ns(win, (focused and win == current) and 0 or ns)
    end
  end
end

local function undim_all()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_get_hl_ns({ winid = win }) == ns then
      vim.api.nvim_win_set_hl_ns(win, 0)
    end
  end
end

function M.toggle()
  enabled = not enabled
  if enabled then
    M.refresh()
  else
    undim_all()
  end
end

---@param opts? { tint?: integer, saturation?: number, ignore_groups?: string[] }
function M.setup(opts)
  config = vim.tbl_deep_extend('force', defaults, opts or {})

  local group = vim.api.nvim_create_augroup('w_dim', { clear = true })

  vim.api.nvim_create_autocmd({ 'WinEnter', 'WinNew', 'TabEnter', 'BufWinEnter' }, {
    group = group,
    callback = M.refresh,
  })

  -- WinEnter doesn't reliably fire after a window closes
  vim.api.nvim_create_autocmd('WinClosed', {
    group = group,
    callback = function()
      vim.schedule(M.refresh)
    end,
  })

  vim.api.nvim_create_autocmd({ 'FocusGained', 'FocusLost' }, {
    group = group,
    callback = function(event)
      focused = event.event == 'FocusGained'
      M.refresh()
    end,
  })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = function()
      dirty = true
      M.refresh()
    end,
  })

  -- rebuilt lazily on the next refresh, so a burst of plugin loads at startup
  -- costs a single rebuild
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'LazyLoad',
    callback = function()
      dirty = true
    end,
  })

  vim.api.nvim_create_user_command('DimToggle', M.toggle, { desc = 'Toggle dimming of unfocused windows' })

  M.refresh()
end

return M
