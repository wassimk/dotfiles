--
-- neotest, neotest-rspec
-- https://github.com/nvim-neotest/neotest
-- https://github.com/olimorris/neotest-rspec
-- https://github.com/zidhuss/neotest-minitest
-- https://github.com/nvim-neotest/neotest-jest
--

return {
  'nvim-neotest/neotest',
  lazy = true,
  cmd = { 'Neotest' },
  dependencies = {
    'olimorris/neotest-rspec',
    { 'zidhuss/neotest-minitest', dev = true },
    'nvim-neotest/neotest-jest',
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-rspec'),
        require('neotest-minitest'),
        require('neotest-jest')({
          jestCommand = 'yarn test',
        }),
      },
    })
  end,
}
