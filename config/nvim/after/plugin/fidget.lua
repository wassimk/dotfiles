--
-- fidget.nvim
-- https://github.com/j-hui/fidget.nvim
--

local has_fidget, fidget = pcall(require, 'fidget')

if not has_fidget then
  return
end

fidget.setup({
  sources = {
    ['null-ls'] = {
      ignore = true,
    },
  },
})
