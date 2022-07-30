--
-- init.lua
--

pcall(require, 'impatient')

require('utils')

-------------------------------------------------------------------------------
-- Options --------------------------------------------------------------------
-------------------------------------------------------------------------------
vim.opt.cursorline = true -- highlight current line
vim.opt.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal
-- vim.opt.nocompatible = true -- This is Vim not Vi
vim.opt.laststatus = 2 -- Always show status line
vim.opt.number = true -- Display line numbers beside buffer
vim.opt.lazyredraw = true -- Don't update while executing macros
vim.opt.backspace = 'indent,eol,start' -- Sane backspace behavior
vim.opt.scrolloff = 4 -- Keep at least 4 lines below cursor
vim.opt.swapfile = false -- Don't create useless swap files
vim.opt.tabstop = 2 -- Two spaces per tab as default
vim.opt.shiftwidth = 2 -- then override with per filteype
vim.opt.softtabstop = 2 -- specific settings via autocmd
vim.opt.expandtab = true -- Convert <tab> to spaces (2 or 4)
vim.opt.relativenumber = true -- Show line numbers relative to cursor position
vim.opt.autoread = true -- Used when edting same file with vim, twice
vim.opt.autoindent = true -- Always auto-indent
vim.opt.showcmd = true -- Show when leader is hit
-- vim.opt.colorcolumn = 100 -- Show colored column at 100 chars"
vim.opt.wildmenu = true -- Command line auto-complete feature
vim.opt.ruler = true -- The status line feature of cursor position
vim.opt.smarttab = true -- Handle tabs, spaces or not smartly
vim.opt.winwidth = 100 -- Set minimum width of current window
vim.opt.hidden = true -- Don't ask to save unmodified buffers, just hide them
vim.opt.complete = vim.opt.complete - 'i' -- Not sure, from sensible
vim.opt.display = vim.opt.display + 'lastline' -- Not sure, from sensible
vim.opt.scrolloff = 1 -- Not sure, from sensible
vim.opt.sidescrolloff = 5 -- Not sure, from sensible
vim.opt.splitright = true -- New veritcle splits to the right
vim.opt.splitbelow = true -- New horizontal split below
vim.opt.inccommand = 'nosplit' -- Live highlight of substitutions
vim.opt.complete = vim.opt.complete + 'kspell'
vim.opt.shortmess = vim.opt.shortmess + 'a' -- Some sane display defaults

-- allow undo even after closing a file
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. '/.config/nvim/undo'

-- use only the system clipboard
vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'

-- load plugins after options in case they override them
require('plugins')

-- vim-test custom run strategy using vim-dispatch
vim.api.nvim_exec(
  [[
  function! DispatchStartStrategy(cmd)
    execute 'Start -title=testing -wait=error ' . a:cmd
  endfunction
]],
  false
)

vim.g['test#custom_strategies'] = { dispatch_start = vim.fn['DispatchStartStrategy'] }
vim.g['test#strategy'] = 'dispatch_start'

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

-- Indent Blankline
require('indent_blankline').setup({
  show_current_context = false,
})

-- Comment.nvim
require('Comment').setup()

-- trouble.nvim
require('trouble').setup()

-- todo-comments.nvim
require('todo-comments').setup()

-- nvim-surround
require('nvim-surround').setup()

-- incline.nvim
require('incline').setup({
  hide = {
    focused_win = true,
    only_win = true,
  },
})

-- more indepth setup/config/etc
require('wassim')
