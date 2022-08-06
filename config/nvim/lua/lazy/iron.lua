--
-- iron.nvim
-- https://github.com/hkupty/iron.nvim
--

local M = {}

function M.setup()
  require('iron.core').setup({
    config = {
      scratch_repl = true,
      repl_open_cmd = 'belowright 20 split',
    },
  })
end

return M
