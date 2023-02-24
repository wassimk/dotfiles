--
-- harpoon
-- https://github.com/ThePrimeagen/harpoon
--

local M = {}

function M.setup()
  local function opts(desc)
    return {
      desc = 'HARPOON: ' .. desc,
    }
  end

  local mark = require('harpoon.mark')
  local ui = require('harpoon.ui')

  vim.keymap.set('n', '<leader>h', mark.add_file, opts('mark file'))
  vim.keymap.set('n', '<C-e>', function()
    require('focus').focus_disable()
    require('harpoon.ui').toggle_quick_menu()
    require('focus').focus_enable()
  end, opts('toggle UI'))

  vim.keymap.set('n', '<M-r>1', function()
    ui.nav_file(1)
  end, opts('goto file 1'))
  vim.keymap.set('n', '<M-r>2', function()
    ui.nav_file(2)
  end, opts('goto file 2'))
  vim.keymap.set('n', '<M-r>3', function()
    ui.nav_file(3)
  end, opts('goto file 3'))
  vim.keymap.set('n', '<M-r>4', function()
    ui.nav_file(4)
  end, opts('goto file 4'))
end

return M
