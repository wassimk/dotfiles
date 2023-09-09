--
-- other.nvim
-- https://github.com/rgroli/other.nvim
--

return {
  'rgroli/other.nvim',
  main = 'other-nvim',
  cmd = 'Other',
  keys = {
    { '<leader>o', '<cmd>Other<cr>', { desc = 'OTHER: other file' } },
  },
  config = {
    showMissingFiles = false,
    mappings = {
      'rails',
      -- going back to source from specs
      {
        pattern = '(.+)/spec/(.*)/(.*)/(.*)_spec.rb',
        target = {
          { target = '%1/db/%3/%4.rb' },
          { target = '%1/app/%3/%4.rb' },
          { target = '%1/%3/%4.rb' },
        },
      },
      {
        pattern = '(.+)/spec/(.*)/(.*)_spec.rb',
        target = {
          { target = '%1/db/%2/%3.rb' },
          { target = '%1/app/%2/%3.rb' },
          { target = '%1/lib/%2/%3.rb' },
        },
      },
      {
        pattern = '(.+)/spec/(.*)/(.*)_(.*)_spec.rb',
        target = {
          { target = '%1/app/%4s/%3_%4.rb' },
        },
      },
    },
  },
}
