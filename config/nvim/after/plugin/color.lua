require('onedark').setup({
  style = 'darker',
})

require('onedark').load()

-- used by vim-matchup plugin
vim.api.nvim_set_hl(0, 'MatchWord', { italic = true })

-- winbar
vim.api.nvim_set_hl(0, 'WinBarPath', { bg = '#282c34' })
vim.api.nvim_set_hl(0, 'WinBarModified', { bg = '#282c34' })

local dap_signs = {
  Breakpoint = 'ﰉ',
  BreakpointCondition = 'ﰊ',
  LogPoint = 'ﯶ',
  Stopped = '',
  BreakpointRejected = 'ﰸ',
}

for type, icon in pairs(dap_signs) do
  local hl = 'Dap' .. type

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
