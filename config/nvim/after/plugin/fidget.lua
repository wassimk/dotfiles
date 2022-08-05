--
-- fidget.nvim
-- https://github.com/j-hui/fidget.nvim
--

if packer_plugins['fidget.nvim'] and packer_plugins['fidget.nvim'].loaded then
  require('fidget').setup({
    sources = {
      ['null-ls'] = {
        ignore = true,
      },
    },
  })
end
