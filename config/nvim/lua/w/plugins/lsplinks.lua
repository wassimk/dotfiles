--
-- lsplinks.nvim
-- https://github.com/icholy/lsplinks.nvim
--

return {
  'icholy/lsplinks.nvim',
  config = function()
    local lsplinks = require('lsplinks')
    lsplinks.setup({ highight = false })
    vim.keymap.set('n', 'gx', lsplinks.gx, { desc = 'Open cursor link via systems open command' })
  end,
}
