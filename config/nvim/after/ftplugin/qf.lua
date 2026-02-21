--
-- qf filetype
--

-- use ESC to close qf window
vim.keymap.set('n', '<Esc>', '<cmd>cclose<bar>lclose<cr>')

-- syntax highlighting via matchadd (replaces syntax/qf.vim)
vim.fn.matchadd('Directory', [[^[^│]*]])
vim.fn.matchadd('Delimiter', [[│]])
vim.fn.matchadd('LineNr', [[│\zs[^│]*\ze│]])

local diagnostic_signs = require('w.diagnostic').signs()
local diagnostic_map = {
  Error = 'DiagnosticSignError',
  Warn = 'DiagnosticSignWarn',
  Info = 'DiagnosticSignInfo',
  Hint = 'DiagnosticSignHint',
}

for name, hl in pairs(diagnostic_map) do
  local icon = diagnostic_signs[name]
  if icon then
    vim.fn.matchadd(hl, [[│[^│]*│\zs ]] .. vim.fn.escape(icon, [[\]]))
  end
end

local lspkind = require('lspkind')
local lsp_kinds = {
  'Text', 'Method', 'Function', 'Constructor', 'Field',
  'Variable', 'Class', 'Interface', 'Module', 'Property',
  'Unit', 'Value', 'Enum', 'Keyword', 'Snippet',
  'Color', 'File', 'Reference', 'Folder', 'EnumMember',
  'Constant', 'Struct', 'Event', 'Operator', 'TypeParameter',
}

for _, kind in ipairs(lsp_kinds) do
  local icon = lspkind.symbolic(kind, { mode = 'symbol', preset = 'codicons' })
  if icon and icon ~= '' then
    vim.fn.matchadd('BlinkCmpKind' .. kind, [[│[^│]*│\zs ]] .. vim.fn.escape(icon, [[\]]))
  end
end
