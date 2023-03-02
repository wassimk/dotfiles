--
-- nvim-bqf
-- https://github.com/kevinhwang91/nvim-bqf
--

local has_bqf, bqf = pcall(require, 'bqf')

if not has_bqf then
  return
end

bqf.setup({
  auto_resize_height = true,
})
