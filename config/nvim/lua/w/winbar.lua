--
-- winbar
--

local M = {}

local winbar_filetype_exclude = {
  'NvimTree',
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

  local file_path = vim.api.nvim_eval_statusline('%f', {}).str
  file_path = string.gsub(file_path, root_path, '')

  local modified = vim.api.nvim_eval_statusline('%M', {}).str == '+' and ' ●' or ''

  -- file_path = file_path:gsub('/', ' > ')

  return '%=' .. '%#WinBarPath#' .. ' ' .. file_path .. '%*' .. '%#WinBarModified#' .. modified .. ' ' .. '%*'
end

function M.setup()
  vim.api.nvim_set_hl(0, 'WinBarPath', { bg = '#282c34' })
  vim.api.nvim_set_hl(0, 'WinBarModified', { fg = '#8EBD6B', bg = '#282c34' })

  vim.opt.winbar = "%{%v:lua.require'w.winbar'.statusline('" .. root_path() .. "')%}"
end

return M
