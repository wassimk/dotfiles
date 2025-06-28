--
-- winbar
--

local M = {}

local winbar_filetype_exclude = {
  'fugitive',
  'help',
  'packer',
  'qf',
  'startuptime',
}

local root_path = function()
  local root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]) or ''
  if root_dir == '' then
    return ''
  else
    local relative_path = vim.fn.fnamemodify(root_dir .. '/', ':~')

    return relative_path
  end
end

function M.statusline(root_path)
  if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
    return ''
  end

  -- Hide winbar for scratch buffers
  if vim.bo.buftype == 'nofile' or vim.api.nvim_buf_get_name(0) == '' then
    return ''
  end

  local file_path = vim.api.nvim_eval_statusline('%f', {}).str
  file_path = string.gsub(file_path, root_path, '')

  local modified = vim.api.nvim_eval_statusline('%M', {}).str == '+' and ' ●' or ''

  -- file_path = file_path:gsub('/', ' > ')

  return '%=' .. '%#WinBarPath#' .. ' ' .. file_path .. '%*' .. '%#WinBarModified#' .. modified .. ' ' .. '%*'
end

function M.setup()
  local background_color = vim.api.nvim_get_hl(0, { name = 'Normal' })
  local cursor_line_color = vim.api.nvim_get_hl(0, { name = 'CursorLine' })
  local diff_added_color = vim.api.nvim_get_hl(0, { name = 'DiffAdded' })

  vim.api.nvim_set_hl(0, 'WinBar', background_color)
  vim.api.nvim_set_hl(0, 'WinBarPath', cursor_line_color)
  vim.api.nvim_set_hl(0, 'WinBarModified', { fg = diff_added_color.fg, bg = cursor_line_color.bg })

  vim.opt.winbar = "%{%v:lua.require'w.winbar'.statusline('" .. root_path() .. "')%}"
end

return M
