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

local my_toggleterm_extension = { sections = { lualine_a = { toggleterm_statusline } }, filetypes = { 'toggleterm' } }
local my_nvimtree_extension = { sections = { lualine_a = { nvimtree_statusline } }, filetypes = { 'NvimTree' } }

lualine.setup({
  options = {
    globalstatus = true,
  },
  theme = 'onedark',
  sections = {
    lualine_a = {
      function()
        return mode_map[vim.api.nvim_get_mode().mode] or '__'
      end,
    },
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
    'quickfix',
    'fugitive',
    'nvim-dap-ui',
    'symbols-outline',
    my_toggleterm_extension,
    my_nvimtree_extension,
  },
})
