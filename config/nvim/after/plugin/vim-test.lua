--
-- vim-test
-- https://github.com/vim-test/vim-test
--

-- vim-test custom run strategy using vim-floaterm
-- vim-test hard codes this floaterm autoclose = 0,
-- which is why we are creating our own strategy
-- TODO: maybe put the test command here with --title=a:cmd
vim.api.nvim_exec(
  [[
  function! FloatermAutocloseStrategy(cmd)
    execute 'FloatermNew '. a:cmd

  endfunction
]],
  false
)

vim.g['test#custom_strategies'] = { floaterm_autoclose = vim.fn['FloatermAutocloseStrategy'] }
vim.g['test#strategy'] = 'floaterm_autoclose'
