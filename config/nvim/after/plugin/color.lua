require('onedark').setup({
  style = 'darker',
})

require('onedark').load()

-- used by vim-matchup plugin
vim.api.nvim_set_hl(0, 'MatchWord', { italic = true })

-- diagnostic icons in gutter
local signs = {
  Error = ' ',
  Warn = ' ',
  Info = ' ',
  Hint = ' ',
}

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type

  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

-- add border to lsp floats, globally
-- TODO: remove border and disable cursorline
local border = 'single'

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
