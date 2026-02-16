--
-- sidekick.nvim
-- https://github.com/folke/sidekick.nvim
--

return {
  'folke/sidekick.nvim',
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
