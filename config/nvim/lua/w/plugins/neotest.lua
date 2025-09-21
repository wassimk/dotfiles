--
-- neotest
--
-- https://github.com/marilari88/neotest-vitest
-- https://github.com/nvim-neotest/neotest
-- https://github.com/nvim-neotest/neotest-jest
-- https://github.com/nvim-neotest/neotest-plenary
-- https://github.com/olimorris/neotest-rspec
-- https://github.com/zidhuss/neotest-minitest
--

return {
  'nvim-neotest/neotest',
  lazy = true,
  cmd = { 'Neotest' },
  keys = {
    {
      '<leader>tn',
      function()
        require('neotest').run.run()
      end,
      mode = 'n',
      desc = 'NEOTEST: nearest',
    },
    {
      '<leader>tf',
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      mode = 'n',
      desc = 'NEOTEST: file',
    },
    {
      '<leader>tw',
      function()
        require('neotest').watch.watch()
      end,
      mode = 'n',
      desc = 'NEOTEST: watch nearest',
    },
    {
      '<leader>ta',
      function()
        require('neotest').run.attach()
      end,
      mode = 'n',
      desc = 'NEOTEST: attach',
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
      mode = 'n',
      desc = 'NEOTEST: last',
    },
    {
      '<leader>th',
      function()
        require('neotest').output.open({ short = true })
      end,
      mode = 'n',
      desc = 'NEOTEST: output float',
    },
    {
      '<leader>tJ',
      function()
        require('neotest').jump.next({ status = 'failed' })
      end,
      mode = 'n',
      desc = 'NEOTEST: jump next failed',
    },
    {
      '<leader>tK',
      function()
        require('neotest').jump.prev({ status = 'failed' })
      end,
      mode = 'n',
      desc = 'NEOTEST: jump previous failed',
    },
    {
      '<leader>to',
      function()
        require('neotest').output_panel.toggle()
      end,
      mode = 'n',
      desc = 'NEOTEST: output panel',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      mode = 'n',
      desc = 'NEOTEST: summary sidebar',
    },
  },
  dependencies = {
    'marilari88/neotest-vitest',
    'nvim-neotest/neotest-plenary',
    'olimorris/neotest-rspec',
    'zidhuss/neotest-minitest',
    { 'nvim-neotest/neotest-jest', dev = true },
  },
  config = function()
    require('neotest').setup({
      summary = {
        open = 'botright vsplit | vertical resize 70',
      },
      watch = {
        enabled = true,
        symbol_queries = {
          ruby = [[
                  ;query
                  ; rspec - class name
                  (call
                    method: (identifier) @_ (#match? @_ "^(describe|context)")
                    arguments: (argument_list (constant) @symbol )
                  )

                  ; rspec - namespaced class name
                  (call
                    method: (identifier)
                    arguments: (argument_list
                      (scope_resolution
                        name: (constant) @symbol))
                  )

                  ; minitest - class being tested
                  (class
                    name: ((constant) @symbol)
                    (#gsub! @symbol "(.*)Test$" "%1")
                  )
          ]],
        },
      },
      adapters = {
        require('neotest-rspec'),
        require('neotest-minitest'),
        require('neotest-jest'),
        (function()
          local vitest_adapter = require('neotest-vitest')
          local original_is_test_file = vitest_adapter.is_test_file

          return vitest_adapter({
            is_test_file = function(file_path)
              -- First try the built-in check
              if original_is_test_file(file_path) then
                return true
              end

              -- If that fails, do custom check
              if string.match(file_path, '/test/javascript/') or string.match(file_path, '/spec/javascripts/') then
                return true
              end
              return false
            end,
          })
        end)(),
        require('neotest-plenary'),
      },
    })
  end,
}
