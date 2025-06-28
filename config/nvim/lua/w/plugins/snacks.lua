--
-- snacks.nvim
-- https://github.com/folke/snacks.nvim
--

-- because i keep hitting it on accident
vim.keymap.set({ 'n', 'c' }, '<C-f>', '', { desc = 'unmap neovim default for Snacks' })

local explorer_opts = {
  follow_file = true,
  focus = 'list',
  auto_close = false,
  jump = { close = false },
  win = {
    list = {
      keys = {
        ['o'] = 'confirm', -- open
        ['O'] = 'explorer_open', -- open with system application
        ['<C-n>'] = 'close',
        ['<c-v>'] = 'edit_vsplit',
        ['<c-x>'] = 'edit_split',
        ['<c-t>'] = 'tab',
      },
    },
  },
}

local picker_opts = {
  win = {
    input = {
      keys = {
        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
        ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
        ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
        ['<c-x>'] = { 'edit_split', mode = { 'i', 'n' } },
      },
    },
    list = {
      keys = {
        ['<c-u>'] = 'preview_scroll_up',
        ['<c-d>'] = 'preview_scroll_down',
        ['<c-x>'] = 'edit_split',
      },
    },
  },
}

local dashboard_opts = {
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
      {
        icon = '󰥩',
        key = '<leader>f',
        desc = 'Find File',
        action = function()
          Snacks.picker.files(picker_opts)
        end,
      },
      {
        icon = '󰩊',
        key = '<leader>s',
        desc = 'Find Text',
        action = function()
          Snacks.picker.grep(picker_opts)
        end,
      },
      { icon = '󰪸 ', key = '<C-f> h', desc = 'Search help' },
      {
        icon = '󰩊',
        key = 'r',
        desc = 'Recent Files',
        action = function()
          Snacks.picker.recent(picker_opts)
        end,
      },
      { icon = '󰪸', key = 's', desc = 'Restore Session', section = 'session' },
      { icon = '󰄧', key = 'p', desc = 'Profile', action = '<cmd>Lazy profile<cr>' },
      { icon = '', key = 'u', desc = 'Update plugins', action = '<cmd>Lazy sync<cr>' },
      { icon = '󱎘', key = 'q', desc = 'Quit', action = ':qa' },
    },
  },
}

return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    lazygit = {},
    explorer = {},
    dashboard = dashboard_opts,
  },
  keys = {
    {
      '<C-n>',
      function()
        Snacks.explorer(explorer_opts)
      end,
      desc = 'FILES: toggle file tree',
    },
    {
      '<leader>f',
      function()
        Snacks.picker.files(picker_opts)
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: find files',
    },
    {
      '<leader>b',
      function()
        Snacks.picker.buffers(picker_opts)
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: find buffers',
    },
    {
      '<leader>g',
      function()
        Snacks.picker.git_status(picker_opts)
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: find git status files',
    },
    {
      '<leader>s',
      function()
        Snacks.picker.grep(picker_opts)
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: live grep',
    },
    {
      '<leader>w',
      function()
        Snacks.picker.grep_word(picker_opts)
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: grep word',
    },
    {
      '<C-f>s',
      function()
        Snacks.picker.search_history(picker_opts)
      end,
      mode = 'n',
      desc = 'SNACKS: grep history',
    },
    {
      '<C-f>c',
      function()
        Snacks.picker.commands()
      end,
      mode = 'n',
      desc = 'SNACKS: commands',
    },
    {
      '<C-r>',
      function()
        Snacks.picker.command_history()
      end,
      mode = 'c',
      desc = 'SNACKS: command history',
    },
    {
      '<C-f>k',
      function()
        Snacks.picker.keymaps()
      end,
      mode = 'n',
      desc = 'SNACKS: keymaps',
    },
    {
      '<C-f>h',
      function()
        Snacks.picker.help()
      end,
      mode = 'n',
      desc = 'SNACKS: help tags',
    },
    {
      'z=',
      function()
        Snacks.picker.spelling()
      end,
      mode = 'n',
      desc = 'SNACKS: spell suggest',
    },
  },
}
