--
-- lualine.nvim
-- https://github.com/nvim-lualine/lualine.nvim
--

local has_lualine, lualine = pcall(require, 'lualine')

if not has_lualine then
  return
end

local mode_map = {
  ['c'] = 'C',
  ['i'] = 'I',
  ['ic'] = 'IC',
  ['n'] = 'N',
  ['t'] = 'T',
  ['v'] = 'V',
  ['V'] = 'VL',
}

local function rhs_character_and_word_counts()
  local rhs = ' '

  if vim.fn.winwidth(0) > 80 then
    local column = vim.fn.virtcol('.')
    local width = vim.fn.virtcol('$')
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local height = vim.api.nvim_buf_line_count(0)

    -- Add padding to stop RHS from changing too much as we move the cursor.
    local padding = #tostring(height) - #tostring(line)
    if padding > 0 then
      rhs = rhs .. (' '):rep(padding)
    end

    rhs = rhs .. 'ℓ ' -- (Literal, \u2113 "SCRIPT SMALL L").
    rhs = rhs .. line
    rhs = rhs .. '/'
    rhs = rhs .. height
    rhs = rhs .. ' 𝚌 ' -- (Literal, \u1d68c "MATHEMATICAL MONOSPACE SMALL C").
    rhs = rhs .. column
    rhs = rhs .. '/'
    rhs = rhs .. width
    rhs = rhs .. ' '

    -- Add padding to stop rhs from changing too much as we move the cursor.
    if #tostring(column) < 2 then
      rhs = rhs .. ' '
    end
    if #tostring(width) < 2 then
      rhs = rhs .. ' '
    end
  end

  return rhs
end

local function toggleterm_statusline()
  ---@diagnostic disable-next-line: undefined-field
  return 'T' .. vim.b.toggle_number
end

local function nvimtree_statusline()
  return 'NVIMTREE'
end

local function is_loclist()
  return vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
end

local function quickfix_label()
  return is_loclist() and 'Location List' or 'Quickfix List'
end

local function quickfix_title()
  if is_loclist() then
    return vim.fn.getloclist(0, { title = 0 }).title
  end
  return vim.fn.getqflist({ title = 0 }).title
end

local function quickfix_line_count()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local size = 0

  if is_loclist() then
    size = vim.fn.getloclist(0, { title = 0, size = true }).size
  end
  size = vim.fn.getqflist({ title = 0, size = true }).size

  return line .. '/' .. size
end

local function mode()
  return mode_map[vim.api.nvim_get_mode().mode] or '__'
end

local my_toggleterm_extension = { sections = { lualine_a = { toggleterm_statusline } }, filetypes = { 'toggleterm' } }

local my_nvimtree_extension = { sections = { lualine_a = { nvimtree_statusline } }, filetypes = { 'NvimTree' } }

local my_telescope_extension = {
  sections = { lualine_a = { mode }, lualine_b = { 'branch', 'diff' }, lualine_x = { 'filetype' } },
  filetypes = { 'TelescopePrompt' },
}

local my_quickfix_extension = {
  sections = {
    lualine_a = { quickfix_label },
    lualine_b = { quickfix_title },
    lualine_z = { quickfix_line_count },
  },
  filetypes = { 'qf' },
}

local function dap_status()
  local status = require('dap').status()

  if status == nil or status == '' then
    return ''
  else
    return 'DAP: ' .. status
  end
end

local my_dap_extension = {
  sections = {
    lualine_a = { { 'filename', file_status = false } },
    lualine_x = { dap_status },
  },
  filetypes = {
    'dap-repl',
    'dapui_console',
    'dapui_watches',
    'dapui_stacks',
    'dapui_breakpoints',
    'dapui_scopes',
  },
}

lualine.setup({
  options = {
    globalstatus = true,
  },
  theme = 'onedark',
  sections = {
    lualine_a = { mode },
    lualine_b = { 'branch', 'diff' },
    lualine_c = {},
    lualine_x = { 'filetype' },
    lualine_y = { 'diagnostics' },
    lualine_z = { rhs_character_and_word_counts },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = {
    'symbols-outline',
    my_dap_extension,
    my_nvimtree_extension,
    my_quickfix_extension,
    my_toggleterm_extension,
    my_telescope_extension,
  },
})
