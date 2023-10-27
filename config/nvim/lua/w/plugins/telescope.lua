--
-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim
--

return {
  'nvim-telescope/telescope.nvim',
  lazy = true,
  version = '*',
  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  keys = {
    {
      '<leader>f',
      function()
        require('telescope.builtin').find_files({ layout_strategy = 'vertical', layout_config = { mirror = true } })
      end,
      mode = { 'n', 'x' },
      desc = 'TELESCOPE: find files',
    },
    {
      '<leader>s',
      function()
        require('telescope.builtin').live_grep({ layout_strategy = 'vertical', layout_config = { mirror = true } })
      end,
      mode = { 'n', 'x' },
      desc = 'TELESCOPE: live grep',
    },
    {
      '<leader>w',
      function()
        require('telescope.builtin').grep_string({ layout_strategy = 'vertical', layout_config = { mirror = true } })
      end,
      mode = { 'n', 'x' },
      desc = 'TELESCOPE: grep word',
    },
    {
      '<C-f>s',
      function()
        require('telescope.builtin').search_history()
      end,
      mode = 'n',
      desc = 'TELESCOPE: grep history',
    },
    {
      '<C-f>c',
      function()
        require('telescope.builtin').commands()
      end,
      mode = 'n',
      desc = 'TELESCOPE: commands',
    },
    {
      '<C-r>',
      function()
        require('telescope.builtin').command_history()
      end,
      mode = 'c',
      desc = 'TELESCOPE: command history',
    },
    {
      '<C-f>k',
      function()
        require('telescope.builtin').keymaps()
      end,
      mode = 'n',
      desc = 'TELESCOPE: keymaps',
    },
    {
      '<C-f>h',
      function()
        require('telescope.builtin').help_tags({
          layout_strategy = 'vertical',
          layout_config = { mirror = true, width = 0.6 },
        })
      end,
      mode = 'n',
      desc = 'TELESCOPE: help tags',
    },
    {
      'z=',
      function()
        require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor())
      end,
      mode = 'n',
      desc = 'TELESCOPE: spell suggest',
    },
  },
  config = function()
    local telescope, actions = require('telescope'), require('telescope.actions')
    local custom_pickers = require('w.custom.telescope.custom_pickers')
    local trouble = require('trouble.providers.telescope')

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ['<C-y>'] = actions.select_default,
            ['<C-e>'] = actions.close,
            ['<C-r>'] = trouble.open_with_trouble,
          },
          n = {
            ['<C-y>'] = actions.select_default,
            ['<C-e>'] = actions.close,
            ['<C-r>'] = trouble.open_with_trouble,
          },
        },
      },
      pickers = {
        git_status = {
          mappings = {
            i = {
              ['<cr>'] = actions.select_default,
              ['<C-y>'] = actions.select_default,
            },
          },
        },
        live_grep = {
          mappings = {
            i = {
              ['<C-f>'] = custom_pickers.actions.set_extension,
              ['<C-l>'] = custom_pickers.actions.set_folders,
            },
          },
        },
      },
    })

    pcall(telescope.load_extension('fzf'))
  end,
}
