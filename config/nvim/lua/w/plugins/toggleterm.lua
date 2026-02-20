--
-- toggleterm.nvim
-- https://github.com/akinsho/toggleterm.nvim
--

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = { 'ToggleTerm', 'TermExec' },
  keys = {
    {
      '<C-Bslash>',
      desc = 'toggleterm: toggle terminal',
    },
  },
  config = function()
    require('toggleterm').setup({
      open_mapping = '<C-Bslash>',
    })

    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = 'term://*',
      callback = function()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<C-Bslash>', '<cmd>ToggleTerm<cr>', opts)

        -- Sidekick manages its own terminal keymaps. Skip window navigation
        -- bindings so they don't interfere with the AI CLI.
        if vim.bo.filetype == 'sidekick_terminal' then
          return
        end
        vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', opts)
        vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', opts)
        vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', opts)
        vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', opts)
      end,
      group = vim.api.nvim_create_augroup('WamTerminalKeymaps', {}),
    })
  end,
}
