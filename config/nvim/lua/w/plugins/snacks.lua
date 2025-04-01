--
-- snacks.nvim
-- https://github.com/folke/snacks.nvim
--

return {
  'folke/snacks.nvim',
  opts = {
    lazygit = {},
    dashboard = {
      width = 70,
      row = 8,
      sections = {
        { section = 'header' },
        { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', limit = 8, indent = 2, padding = 1 },
        { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        { section = 'startup' },
      },
      preset = {
        keys = {
          { icon = '', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = '󰥩', key = '<leader>f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = '󰩊', key = '<leader>s', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = '󰪸 ', key = '<C-f> h', desc = 'Search help' },
          { icon = '󰩊', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = '󰪸', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰄧', key = 'p', desc = 'Profile', action = '<cmd>Lazy profile<cr>' },
          { icon = '', key = 'u', desc = 'Update plugins', action = '<cmd>Lazy sync<cr>' },
          { icon = '󱎘', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
    },
  },
}
