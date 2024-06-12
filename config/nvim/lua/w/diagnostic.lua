--
-- diagnostic
--

local M = {}

function M.signs(abbreviated)
  abbreviated = abbreviated or false

  local full = {
    Error = '',
    Warn = '',
    Info = '',
    Hint = '',
  }

  local abbrev = {
    E = full.Error,
    W = full.Warn,
    I = full.Info,
    N = full.Hint,
  }

  if abbreviated then
    return abbrev
  else
    return full
  end
end

function M.setup()
  -- global configuration
  vim.diagnostic.config({
    virtual_text = false,
    underline = false,
    signs = { priority = 10 },
    float = {
      source = 'if_many',
    },
  })

  -- keymaps
  local function opts(desc)
    return {
      desc = 'DIAGNOSTIC: ' .. desc,
    }
  end
  vim.keymap.set('n', '<leader>dn', function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, opts('jump next'))
  vim.keymap.set('n', '<leader>dp', function()
    vim.diagnostic.jump({ count = -1, foat = true })
  end, opts('jump previous'))
  vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, opts('open float'))
  vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, opts('current document'))
  vim.keymap.set('n', '<leader>dw', vim.diagnostic.setqflist, opts('current workspace'))

  -- icons in gutter
  for type, icon in pairs(M.signs()) do
    local hl = 'DiagnosticSign' .. type

    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end

return M
