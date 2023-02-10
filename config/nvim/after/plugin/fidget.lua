--
-- fidget.nvim
-- https://github.com/j-hui/fidget.nvim
--

local has_fidget, fidget = pcall(require, 'fidget')

if has_fidget then
  fidget.setup({
    sources = {
      ['null-ls'] = {
        ignore = true,
      },
    },
  })
end
