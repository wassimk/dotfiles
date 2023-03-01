--
-- vim-test
-- https://github.com/vim-test/vim-test
--

local M = {}

function M.setup()
  vim.g['test#custom_strategies'] = {
    my_toggleterm = function(cmd)
      local Terminal = require('toggleterm.terminal').Terminal

      Terminal:new({
        cmd = cmd,
        close_on_exit = false,
        direction = 'float',
        on_exit = function(terminal, _, exit_code)
          if exit_code == 0 then
            terminal:close()
          end
        end,
      }):toggle()
    end,
  }

  vim.g['test#strategy'] = 'my_toggleterm'
end

return M
