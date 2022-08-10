--
-- vim-test
-- https://github.com/vim-test/vim-test
--

local M = {}

function M.setup()
  -- vim-test custom run strategy using vim-floaterm
  -- because vim-test hard codes its floaterm autoclose to 0
  -- TODO: maybe put the test command here with --title=a:cmd
  vim.api.nvim_exec(
    [[
  function! FloatermAutocloseStrategy(cmd)
    execute 'FloatermNew --autoclose=1 '. a:cmd

  endfunction
]],
    false
  )

  vim.g['test#custom_strategies'] = { floaterm_autoclose = vim.fn['FloatermAutocloseStrategy'] }
  vim.g['test#strategy'] = 'floaterm_autoclose'
end

return M
