--
-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim
--

local telescope, builtin, actions = require('telescope'), require('telescope.builtin'), require('telescope.actions')
local custom_pickers = require('wassim.telescope_custom_pickers')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ['<C-y>'] = actions.select_default,
        ['<C-e>'] = actions.close,
      },
      n = {
        ['<C-y>'] = actions.select_default,
        ['<C-e>'] = actions.close,
      },
    },
  },
  pickers = {
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

telescope.load_extension('dap')
telescope.load_extension('fzf')
telescope.load_extension('ui-select')

-- keymaps
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<C-f>', '', opts) -- i keep hitting this and it scrolls the screen!
vim.keymap.set('n', '<C-f>f', builtin.find_files, opts)
vim.keymap.set('n', '<C-f>w', builtin.grep_string, opts)
vim.keymap.set('n', '<C-f>g', custom_pickers.live_grep, opts)
vim.keymap.set('n', '<C-f>b', builtin.current_buffer_fuzzy_find, opts)
vim.keymap.set('n', '<C-f>h', builtin.help_tags, opts)
vim.keymap.set('n', '<C-f>c', builtin.commands, opts)
vim.keymap.set('n', '<C-f>k', builtin.keymaps, opts)
