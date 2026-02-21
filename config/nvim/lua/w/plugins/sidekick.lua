--
-- sidekick.nvim
-- https://github.com/folke/sidekick.nvim
--

return {
  'folke/sidekick.nvim',
  init = function()
    vim.api.nvim_create_autocmd('WinEnter', {
      group = vim.api.nvim_create_augroup('sidekick_insert_on_click', { clear = true }),
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].filetype == 'sidekick_terminal' then
          vim.schedule(function()
            if vim.api.nvim_get_mode().mode ~= 't' then
              vim.cmd.startinsert()
            end
          end)
        end
      end,
    })
  end,
  opts = {
    cli = {
      mux = {
        enabled = true,
        backend = 'tmux',
      },
    },
  },
  keys = {
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Toggle AI',
      mode = { 'n', 'v' },
    },
    -- Ctrl+/ works from any mode including terminal, so you can toggle
    -- sidekick without leaving the terminal buffer first.
    {
      '<C-_>',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Toggle AI',
      mode = { 'n', 'v', 't' },
    },
    {
      '<leader>ab',
      function()
        require('sidekick.cli').send({ msg = '{file}' })
      end,
      desc = 'Send buffer',
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').send({ msg = '{selection}' })
      end,
      desc = 'Send selection',
      mode = 'v',
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send({ msg = '{this}' })
      end,
      desc = 'Send this',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').toggle({ focus = true })
      end,
      desc = 'Focus terminal',
    },
    {
      '<leader>ad',
      function()
        require('sidekick.cli').close()
      end,
      desc = 'Detach',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      desc = 'Select prompt',
    },
    {
      '<leader>al',
      function()
        require('sidekick.cli').select()
      end,
      desc = 'Select tool',
    },
    -- Tab accept is handled by blink.cmp keymap chain (sidekick NES → inline completion → fallback)
  },
}
