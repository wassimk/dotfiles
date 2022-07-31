local M = {}

local winbar_filetype_exclude = {
  'NvimTree',
  'Trouble',
  'fugitive',
  'help',
  'packer',
  'qf',
  'startuptime',
}

vim.api.nvim_set_hl(0, 'WinBarPath', { bg = '#282c34' })
vim.api.nvim_set_hl(0, 'WinBarModified', { bg = '#282c34' })

function M.statusline()
  if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
    return ''
  end

  local file_path = vim.api.nvim_eval_statusline('%f', {}).str
  local modified = vim.api.nvim_eval_statusline('%M', {}).str == '+' and '[+]' or ''

  -- file_path = file_path:gsub('/', ' > ')

  return '%=' .. '%#WinBarPath#' .. ' ' .. file_path .. '%*' .. '%#WinBarModified#' .. modified .. ' ' .. '%*'
end

return M
