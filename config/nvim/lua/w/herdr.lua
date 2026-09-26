--
-- herdr
-- https://herdr.dev/docs/cli-reference/
--
-- Drive a Claude Code pane in the current herdr workspace from neovim:
-- find or create it, focus it, and send file references or selections
-- into its prompt without pressing Enter.
--

local M = {}

-- pane ids we created, by workspace, so a pane claude has not been detected
-- in yet is still found
local cache = {}

local function herdr_bin()
  return vim.env.HERDR_BIN_PATH or 'herdr'
end

--- Run a herdr CLI command. Returns stdout, or nil after notifying on failure.
---@param args string[]
---@param opts? { quiet?: boolean }
---@return string|nil
local function run(args, opts)
  opts = opts or {}
  local result = vim.system(vim.list_extend({ herdr_bin() }, args), { text = true }):wait()
  if result.code ~= 0 then
    if not opts.quiet then
      vim.notify(('herdr %s failed: %s'):format(args[1], vim.trim(result.stderr or '')), vim.log.levels.ERROR)
    end
    return nil
  end
  return result.stdout
end

local function decode(stdout)
  local ok, data = pcall(vim.json.decode, stdout)
  return ok and data or nil
end

local function relpath(path)
  return vim.fn.fnamemodify(path, ':.')
end

--- Pane id of the claude agent in a workspace from decoded `herdr agent list`.
---@param agents table
---@param workspace_id string
---@return string|nil
function M.find_agent_pane(agents, workspace_id)
  local list = agents and agents.result and agents.result.agents or {}
  for _, agent in ipairs(list) do
    if agent.workspace_id == workspace_id and agent.agent == 'claude' then
      return agent.pane_id
    end
  end
  return nil
end

--- Fenced block for lines first..last of path.
---@return string
function M.format_selection(path, first, last, lines, filetype)
  return ('%s:%d-%d\n```%s\n%s\n```\n'):format(path, first, last, filetype or '', table.concat(lines, '\n'))
end

local function pane_alive(pane_id)
  return run({ 'pane', 'get', pane_id }, { quiet = true }) ~= nil
end

--- Existing claude pane for this workspace, or nil.
function M.agent_pane()
  local ws = vim.env.HERDR_WORKSPACE_ID
  if cache[ws] and pane_alive(cache[ws]) then
    return cache[ws]
  end
  cache[ws] = nil
  local data = decode(run({ 'agent', 'list' }) or '')
  cache[ws] = M.find_agent_pane(data, ws)
  return cache[ws]
end

--- Split right of this pane at the project root and start claude there.
function M.create_pane()
  local root = vim.fs.root(0, '.git') or vim.uv.cwd()
  local data = decode(
    run({ 'pane', 'split', '--pane', vim.env.HERDR_PANE_ID, '--direction', 'right', '--ratio', '0.4', '--cwd', root })
      or ''
  )
  local pane = data and data.result and data.result.pane and data.result.pane.pane_id
  if not pane then
    vim.notify('herdr: could not create a claude pane', vim.log.levels.ERROR)
    return nil
  end
  -- run through the pane's shell so the `claude` zsh wrapper applies
  run({ 'pane', 'run', pane, 'claude' })
  cache[vim.env.HERDR_WORKSPACE_ID] = pane
  return pane
end

function M.ensure_pane()
  return M.agent_pane() or M.create_pane()
end

--- Focus the claude pane, creating it first when needed.
function M.focus()
  local pane = M.ensure_pane()
  if not pane then
    return
  end
  -- agent focus only works once herdr recognises the agent; fall back to the
  -- neighbour to the right, which is where create_pane put it
  if run({ 'agent', 'focus', pane }, { quiet = true }) == nil then
    run({ 'pane', 'focus', '--direction', 'right', '--pane', vim.env.HERDR_PANE_ID })
  end
end

--- Type text into the claude prompt without submitting it.
function M.send(text)
  local pane = M.ensure_pane()
  if pane then
    run({ 'pane', 'send-text', pane, text })
  end
end

function M.close()
  local pane = M.agent_pane()
  if pane then
    run({ 'pane', 'close', pane })
    cache[vim.env.HERDR_WORKSPACE_ID] = nil
  end
end

function M.file_ref()
  return '@' .. relpath(vim.api.nvim_buf_get_name(0)) .. ' '
end

function M.this_ref()
  return ('@%s:%d '):format(relpath(vim.api.nvim_buf_get_name(0)), vim.api.nvim_win_get_cursor(0)[1])
end

function M.selection_block()
  local first, last = vim.fn.line('v'), vim.fn.line('.')
  if first > last then
    first, last = last, first
  end
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  return M.format_selection(relpath(vim.api.nvim_buf_get_name(0)), first, last, lines, vim.bo.filetype)
end

local function leave_visual()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

function M.setup()
  if vim.env.HERDR_ENV ~= '1' then
    return
  end
  local map = vim.keymap.set
  -- Ctrl+/ from any mode, matching the old sidekick toggle
  map({ 'n', 'v', 't' }, '<C-_>', M.focus, { desc = 'focus claude pane' })
  map('n', '<leader>aa', M.focus, { desc = 'focus claude pane' })
  map('n', '<leader>af', M.focus, { desc = 'focus claude pane' })
  map('n', '<leader>ab', function()
    M.send(M.file_ref())
  end, { desc = 'send buffer ref to claude' })
  map('v', '<leader>as', function()
    M.send(M.selection_block())
    leave_visual()
  end, { desc = 'send selection to claude' })
  map('n', '<leader>at', function()
    M.send(M.this_ref())
  end, { desc = 'send cursor ref to claude' })
  map('n', '<leader>ad', M.close, { desc = 'close claude pane' })
end

return M
