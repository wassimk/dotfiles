--
-- nvim-bqf
-- https://github.com/kevinhwang91/nvim-bqf
--

return {
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
  version = '*',
  config = { auto_resize_height = true },
  dependencies = {
    'junegunn/fzf',
    build = function()
      vim.fn['fzf#install']()
    end,
  },
}
