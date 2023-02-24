--
-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim
--

local telescope, builtin, actions = require('telescope'), require('telescope.builtin'), require('telescope.actions')
local custom_pickers = require('w.plugin.telescope.custom_pickers')

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

telescope.load_extension('dap')
telescope.load_extension('fzf')
telescope.load_extension('ui-select')

-- keymaps
local function opts(desc)
  return {
    desc = 'TELESCOPE: ' .. desc,
  }
end

vim.keymap.set('n', '<C-f>', '', opts('unmap neovim default'))
vim.keymap.set('n', '<C-f>f', builtin.find_files, opts('files'))
vim.keymap.set('n', '<C-f>w', builtin.grep_string, opts('grep word'))
vim.keymap.set('n', '<C-f>l', custom_pickers.live_grep, opts('live grep'))
vim.keymap.set('n', '<C-f>gs', builtin.git_status, opts('git status'))
vim.keymap.set('n', '<C-f>gt', builtin.git_stash, opts('git stash'))
vim.keymap.set('n', '<C-f>gc', builtin.git_commits, opts('git commits'))
vim.keymap.set('n', '<C-f>h', builtin.help_tags, opts('help tags'))
vim.keymap.set('n', '<C-f>c', builtin.commands, opts('commands'))
vim.keymap.set('n', '<C-f>k', builtin.keymaps, opts('keymaps'))
