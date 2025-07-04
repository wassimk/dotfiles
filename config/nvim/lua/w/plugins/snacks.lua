--
-- snacks.nvim
-- https://github.com/folke/snacks.nvim
--

-- because i keep hitting it on accident
vim.keymap.set({ 'n', 'c' }, '<C-f>', '', { desc = 'unmap neovim default for Snacks' })

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
        ['<C-v>'] = 'edit_vsplit',
        ['<C-x>'] = 'edit_split',
        ['<C-t>'] = 'tab',
        ['<C-y>'] = 'confirm',
      },
    },
  },
}

local common_picker_keymaps = {
  input = {
    keys = {
      ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
      ['<C-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
      ['<C-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
      ['<C-x>'] = { 'edit_split', mode = { 'i', 'n' } },
      ['<C-y>'] = { 'confirm', mode = { 'n', 'i' } },
    },
  },
  list = {
    keys = {
      ['<C-u>'] = 'preview_scroll_up',
      ['<C-d>'] = 'preview_scroll_down',
      ['<C-x>'] = 'edit_split',
      ['<C-y>'] = 'confirm',
    },
  },
}
local file_picker_keymaps = vim.tbl_extend('force', common_picker_keymaps, {
  input = {
    keys = {
      ['<C-l>'] = { 'search_in_directory', mode = { 'i', 'n' } },
      ['<C-f>'] = { 'filter_by_extension', mode = { 'i', 'n' } },
      ['C'] = { 'copy_file_path', mode = { 'i', 'n' } },
      ['D'] = { 'diff', mode = { 'i', 'n' } },
    },
  },
  list = {
    keys = {
      ['<C-l>'] = 'search_in_directory',
      ['<C-f>'] = 'filter_by_extension',
      ['C'] = 'copy_file_path',
      ['D'] = 'diff',
    },
  },
})

local search_picker_keymaps = vim.tbl_extend('force', common_picker_keymaps, {
  input = {
    keys = {
      ['<C-l>'] = { 'choose_directory', mode = { 'i', 'n' } },
      ['<C-f>'] = { 'filter_by_extension', mode = { 'i', 'n' } },
    },
  },
  list = {
    keys = {
      ['<C-l>'] = 'choose_directory',
      ['<C-f>'] = 'filter_by_extension',
    },
  },
})

local filter_by_extension_action = {
  action = function(picker)
    local items = picker:items()
    local extensions = {}
    local ext_counts = {}

    for _, item in ipairs(items) do
      local ext = vim.fn.fnamemodify(item.file, ':e')
      if ext ~= '' then
        if not extensions[ext] then
          extensions[ext] = true
          ext_counts[ext] = 1
        else
          ext_counts[ext] = ext_counts[ext] + 1
        end
      end
    end

    local ext_list = vim.tbl_keys(extensions)
    if vim.tbl_isempty(ext_list) then
      Snacks.notify.warn('No file extensions found')
      return
    end

    table.sort(ext_list)

    vim.ui.select(ext_list, {
      prompt = 'Filter by extension:',
      format_item = function(ext)
        return string.format('%s (%d files)', ext, ext_counts[ext])
      end,
    }, function(choice)
      if choice then
        local current_input = picker.input:get() or ''
        local search_term = current_input:match('^(.-)%s*file:') or current_input
        search_term = search_term:gsub('%s+$', '') -- trim trailing spaces

        local new_filter = 'file:' .. choice .. '$ '
        if search_term ~= '' then
          new_filter = new_filter .. search_term
        end

        picker.input:set(new_filter)
        vim.schedule(function()
          vim.api.nvim_feedkeys('A', 'n', false)
        end)
      end
    end)
  end,
}

local search_picker_actions = {
  filter_by_extension = filter_by_extension_action,
  choose_directory = {
    action = function(picker)
      local input = picker.input:get() or ''
      local search_term = picker.finder.filter.search or ''

      local query = (input ~= '' and input) or search_term
      if query == '' then
        Snacks.notify.warn('Enter a search term first')
        return
      end

      picker:close()

      Snacks.picker.files({
        prompt = 'Directory to search > ',
        cmd = 'fd',
        args = { '--type', 'd' },
        transform = function(item)
          return vim.fn.isdirectory(item.file) == 1
        end,
        win = vim.tbl_extend('force', common_picker_keymaps, {
          input = {
            keys = {
              ['<CR>'] = { 'select_directory_for_search', mode = { 'i', 'n' } },
              ['<C-y>'] = { 'select_directory_for_search', mode = { 'i', 'n' } },
            },
          },
          list = {
            keys = {
              ['<CR>'] = 'select_directory_for_search',
              ['<C-y>'] = 'select_directory_for_search',
            },
          },
        }),
        actions = {
          select_directory_for_search = {
            action = function(_, item)
              if not item then
                return
              end

              Snacks.picker.grep({
                search = query,
                cwd = Snacks.picker.util.dir(item),
                show_empty = true,
                hidden = true,
                ignored = true,
                follow = false,
                supports_live = true,
              })
            end,
          },
        },
      })
    end,
  },
}

local file_picker_actions = {
  filter_by_extension = filter_by_extension_action,
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

local file_picker_opts = {
  win = file_picker_keymaps,
  actions = file_picker_actions,
}

local search_picker_opts = {
  win = search_picker_keymaps,
  actions = search_picker_actions,
}

local picker_opts = {
  enabled = true,
  ui_select = true,
  sources = {
    explorer = explorer_opts,
    smart = file_picker_opts,
    files = file_picker_opts,
    buffers = file_picker_opts,
    grep = search_picker_opts,
    grep_word = search_picker_opts,
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
    bigfile = {},
    quickfile = {},
    scroll = {},
    words = {},
    explorer = {}, -- configured in picker_opts
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
