--
-- init.lua
--

pcall(require, 'impatient')

require('plugins').setup()
require('wassim')

---------------
-- Searching --
---------------
if vim.fn.executable('rg') == 1 then
  -- use rg for grep
  vim.opt.grepprg = 'rg -H --no-heading --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m,%f'

  -- use rg for ack
  vim.g.ackprg = 'rg --vimgrep'
end

-- Loupe
vim.g.LoupeVeryMagic = 0

-- Telescope
require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')

-- nvim-tree
require('nvim-tree').setup({
  view = {
    hide_root_folder = false,
    mappings = {
      list = {
        { key = '?', action = 'toggle_help' },
      },
    },
  },
})

-- QFEnter for quickfix keymaps
vim.g.qfenter_keymap = {
  vopen = { '<C-v>' },
  hopen = { '<C-x>' },
  topen = { '<C-t>' },
}

-- Indent Blankline
require('indent_blankline').setup({
  show_current_context = false,
})

-- Comment.nvim
require('Comment').setup()

-- trouble.nvim
require('trouble').setup()

-- todo-comments.nvim
-- NOTE: workaround until issue is fixed upstream
-- https://github.com/folke/todo-comments.nvim/issues/97
local hl = require('todo-comments.highlight')
local highlight_win = hl.highlight_win
hl.highlight_win = function(win, force)
  pcall(highlight_win, win, force)
end

require('todo-comments').setup({
  sign_priority = 5, -- lower than gitsigns
})

-- nvim-surround
require('nvim-surround').setup()

-- refactoring.nvim
require('refactoring').setup()

-- fidget.nvim
require('fidget').setup({
  sources = {
    ['null-ls'] = {
      ignore = true,
    },
  },
})

-- focus.nvim
require('focus').setup({
  width = 120,
  excluded_buftypes = { 'nofile', 'prompt', 'popup', 'quickfix' },
})

-- iron.nvim repl
local iron = require('iron.core')

iron.setup({
  config = {
    scratch_repl = true,
    repl_open_cmd = 'belowright 20 split',
  },
})
