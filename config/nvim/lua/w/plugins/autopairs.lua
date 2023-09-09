--
-- nvim-autopairs
-- https://github.com/windwp/nvim-autopairs
--

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {
    check_ts = true,
    map_cr = true,
  },
}
