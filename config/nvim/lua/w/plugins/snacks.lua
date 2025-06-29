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

local common_picker_keymaps = {
  input = {
    keys = {
      ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
      ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
      ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
      ['<c-x>'] = { 'edit_split', mode = { 'i', 'n' } },
      ['<c-l>'] = { 'search_in_directory', mode = { 'i', 'n' } },
      ['C'] = { 'copy_file_path', mode = { 'i', 'n' } },
      ['D'] = { 'diff', mode = { 'i', 'n' } },
    },
  },
  list = {
    keys = {
      ['<c-u>'] = 'preview_scroll_up',
      ['<c-d>'] = 'preview_scroll_down',
      ['<c-x>'] = 'edit_split',
      ['<c-l>'] = 'search_in_directory',
      ['C'] = 'copy_file_path',
      ['D'] = 'diff',
    },
  },
}

local common_picker_actions = {
  copy_file_path = {
    action = function(_, item)
      if not item then
        return
      end

      local vals = {
        ['BASENAME'] = vim.fn.fnamemodify(item.file, ':t:r'),
        ['EXTENSION'] = vim.fn.fnamemodify(item.file, ':t:e'),
        ['FILENAME'] = vim.fn.fnamemodify(item.file, ':t'),
        ['PATH'] = item.file,
        ['PATH (CWD)'] = vim.fn.fnamemodify(item.file, ':.'),
        ['PATH (HOME)'] = vim.fn.fnamemodify(item.file, ':~'),
        ['URI'] = vim.uri_from_fname(item.file),
      }

      local options = vim.tbl_filter(function(val)
        return vals[val] ~= ''
      end, vim.tbl_keys(vals))
      if vim.tbl_isempty(options) then
        vim.notify('No values to copy', vim.log.levels.WARN)
        return
      end
      table.sort(options)
      vim.ui.select(options, {
        prompt = 'Choose to copy to clipboard:',
        format_item = function(list_item)
          return ('%s: %s'):format(list_item, vals[list_item])
        end,
      }, function(choice)
        local result = vals[choice]
        if result then
          vim.fn.setreg('+', result)
          Snacks.notify.info('Yanked `' .. result .. '`')
        end
      end)
    end,
  },
  search_in_directory = {
    action = function(_, item)
      if not item then
        return
      end
      local dir = vim.fn.fnamemodify(item.file, ':p:h')
      Snacks.picker.grep({
        cwd = dir,
        show_empty = true,
        hidden = true,
        ignored = true,
        follow = false,
        supports_live = true,
      })
    end,
  },
  diff = {
    action = function(picker)
      picker:close()
      local sel = picker:selected()
      if #sel > 0 and sel then
        Snacks.notify.info(sel[1].file)
        vim.cmd('tabnew ' .. sel[1].file)
        vim.cmd('vert diffs ' .. sel[2].file)
        Snacks.notify.info('Diffing ' .. sel[1].file .. ' against ' .. sel[2].file)
        return
      end

      Snacks.notify.info('Select two entries for the diff')
    end,
  },
}

local common_picker_opts = {
  win = common_picker_keymaps,
  actions = common_picker_actions,
}

local picker_opts = {
  enabled = true,
  ui_select = true,
  sources = {
    explorer = explorer_opts,
    files = common_picker_opts,
    buffers = common_picker_opts,
    smart = common_picker_opts,
    grep = common_picker_opts,
    grep_word = common_picker_opts,
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
          Snacks.picker.files()
        end,
      },
      {
        icon = '󰩊',
        key = '<leader>s',
        desc = 'Find Text',
        action = function()
          Snacks.picker.grep()
        end,
      },
      { icon = '󰪸 ', key = '<C-f> h', desc = 'Search help' },
      {
        icon = '󰩊',
        key = 'r',
        desc = 'Recent Files',
        action = function()
          Snacks.picker.recent()
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
    image = {},
    input = {},
    picker = picker_opts,
    dashboard = dashboard_opts,
  },
  keys = {
    {
      '<C-n>',
      function()
        Snacks.explorer()
      end,
      desc = 'FILES: toggle explorer',
    },
    {
      '<leader>f',
      function()
        Snacks.picker.smart()
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: smart',
    },
    {
      '<leader>b',
      function()
        Snacks.picker.buffers()
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: buffers',
    },
    {
      '<leader>s',
      function()
        Snacks.picker.grep()
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: grep',
    },
    {
      '<leader>w',
      function()
        Snacks.picker.grep_word()
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: grep word',
    },
    {
      '<leader>g',
      function()
        Snacks.picker.git_status()
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: git status',
    },
    {
      '<C-f>a',
      function()
        Snacks.picker.pickers()
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: all pickers',
    },
    {
      '<C-f>i',
      function()
        Snacks.picker.icons()
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: icons',
    },
    {
      '<C-f>l',
      function()
        Snacks.picker.highlights()
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: highlights',
    },
    {
      '<C-f>f',
      function()
        Snacks.picker.files()
      end,
      mode = { 'n', 'x' },
      desc = 'SNACKS: files',
    },
    {
      '<C-f>s',
      function()
        Snacks.picker.search_history()
      end,
      mode = 'n',
      desc = 'SNACKS: search history',
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
