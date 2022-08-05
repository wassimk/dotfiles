--
-- focus.nvim
-- https://github.com/beauwilliams/focus.nvim
--

if packer_plugins['focus.nvim'] and packer_plugins['focus.nvim'].loaded then
  require('focus').setup({
    width = 120,
    excluded_buftypes = { 'nofile', 'prompt', 'popup', 'quickfix' },
  })
end
