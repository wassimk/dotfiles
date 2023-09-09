--
-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim
--

return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = {
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    local telescope, builtin, actions = require('telescope'), require('telescope.builtin'), require('telescope.actions')
    local custom_pickers = require('w.plugin.telescope.custom_pickers')
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
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    pcall(telescope.load_extension('fzf'))
    pcall(telescope.load_extension('ui-select'))

    -- keymaps
    local function opts(desc)
      return {
        desc = 'TELESCOPE: ' .. desc,
      }
    end

    vim.keymap.set({ 'n', 'c' }, '<C-f>', '', opts('unmap neovim default'))

    vim.keymap.set({ 'n', 'x' }, '<leader>f', function()
      builtin.find_files({ layout_strategy = 'vertical', layout_config = { mirror = true } })
    end, opts('find files'))

    vim.keymap.set({ 'n', 'x' }, '<leader>s', function()
      builtin.live_grep({ layout_strategy = 'vertical', layout_config = { mirror = true } })
    end, opts('live grep'))

    vim.keymap.set('n', '<leader>w', function()
      builtin.grep_string({ layout_strategy = 'vertical', layout_config = { mirror = true } })
    end, opts('grep word'))

    vim.keymap.set('n', '<C-f>s', builtin.search_history, opts('grep history'))

    vim.keymap.set('n', '<C-f>c', builtin.commands, opts('commands'))

    vim.keymap.set('c', '<C-r>', builtin.command_history, opts('command history'))

    vim.keymap.set('n', '<C-f>k', builtin.keymaps, opts('keymaps'))

    vim.keymap.set('n', '<C-f>gs', function()
      builtin.git_status({ layout_strategy = 'vertical', layout_config = { mirror = true } })
    end, opts('git status'))

    vim.keymap.set('n', '<C-f>gt', function()
      builtin.git_stash({ layout_strategy = 'vertical', layout_config = { mirror = true } })
    end, opts('git stash'))

    vim.keymap.set('n', '<C-f>gc', function()
      builtin.git_commits({ layout_strategy = 'vertical', layout_config = { mirror = true } })
    end, opts('git commits'))

    vim.keymap.set('n', '<C-f>h', function()
      builtin.help_tags({ layout_strategy = 'vertical', layout_config = { mirror = true, width = 0.6 } })
    end, opts('help tags'))

    vim.keymap.set('n', 'z=', function()
      builtin.spell_suggest(require('telescope.themes').get_cursor())
    end, opts('spell suggest'))
  end,
}
