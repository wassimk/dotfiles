local mode_map = {
  ['c']  = 'C',
  ['i']  = 'I',
  ['ic'] = 'IC',
  ['n']  = 'N',
  ['t']  = 'T',
  ['v']  = 'V',
  ['V']  = 'VL'
}

require('lualine').setup {
  options = {
    disabled_filetypes = {},
    globalstatus = false,
  },
  sections = {
    lualine_a = { function()
      return mode_map[vim.api.nvim_get_mode().mode] or '__'
    end },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype', "require('lsp-status').status()" },
    lualine_y = { 'diagnostics' },
    lualine_z = { "'ℓ %l 𝚌 %v'" }, -- ℓ symbol breaks without the inner quotes
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = { 'quickfix', 'nvim-tree', 'fugitive' }
}
