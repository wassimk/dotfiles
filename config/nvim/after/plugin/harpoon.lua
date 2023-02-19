--
-- harpoon
-- https://github.com/ThePrimeagen/harpoon
--

local has_harpoon = pcall(require, 'harpoon')

if not has_harpoon then
  return
end

local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<leader>h', mark.add_file)
vim.keymap.set('n', '<C-e>', '<cmd>Telescope harpoon marks<CR>')

vim.keymap.set('n', '<M-r>1', function()
  ui.nav_file(1)
end)
vim.keymap.set('n', '<M-r>2', function()
  ui.nav_file(2)
end)
vim.keymap.set('n', '<M-r>3', function()
  ui.nav_file(3)
end)
vim.keymap.set('n', '<M-r>4', function()
  ui.nav_file(4)
end)
