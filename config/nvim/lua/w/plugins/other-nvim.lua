--
-- other.nvim
-- https://github.com/rgroli/other.nvim
--

return {
  'rgroli/other.nvim',
  main = 'other-nvim',
  -- cmd = 'Other',
  keys = {
    {
      '<leader>o',
      '<cmd>Other<cr>',
      desc = 'Other file',
    },
  },
  opts = {
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
      -- javascript in rails
      {
        pattern = '(.+)/test/javascript/(.*)/(.*)_test.js',
        target = {
          { target = '%1/app/javascript/%2/%3.jsx' },
          { target = '%1/app/javascript/%2/%3.js' },
        },
      },
      {
        pattern = '(.+)/app/javascript/(.*)/(.*).jsx?',
        target = {
          { target = '%1/test/javascript/%2/%3_test.js' },
        },
      },
    },
  },
}
