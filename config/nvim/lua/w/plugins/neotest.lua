--
-- neotest, neotest-rspec
-- https://github.com/nvim-neotest/neotest
-- https://github.com/olimorris/neotest-rspec
--

return {
  'nvim-neotest/neotest',
  lazy = true,
  cmd = { 'Neotest' },
  dependencies = {
    'olimorris/neotest-rspec',
    { 'zidhuss/neotest-minitest', dev = true },
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-rspec'),
        require('neotest-minitest'),
      },
    })
  end,
}
