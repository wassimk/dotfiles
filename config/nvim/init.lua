--
-- init.lua
--

require('plugins')

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
-- vim.opt.noswapfile = true -- Don't know why but I don't need it
vim.opt.tabstop = 2 -- Two spaces per tab as default
vim.opt.shiftwidth = 2 --     then override with per filteype
vim.opt.softtabstop = 2 --     specific settings via autocmd
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
vim.opt.hidden = true -- Hide unsaved buffers
vim.opt.complete = vim.opt.complete - 'i' -- Not sure, from sensible
vim.opt.display = vim.opt.display + 'lastline' -- Not sure, from sensible
vim.opt.scrolloff = 1 -- Not sure, from sensible
vim.opt.sidescrolloff = 5 -- Not sure, from sensible
vim.opt.splitright = true -- New veritcle splits to the right
vim.opt.splitbelow = true -- New horizontal split below
vim.opt.inccommand = 'nosplit' -- Live highlight of substitutions
-- vim.opt.nofoldenable = true -- Disable folding
vim.opt.complete = vim.opt.complete + 'kspell'


-- Use system clipboard
vim.opt.clipboard = 'unnamed'

-- Automatic, language-dependent indentation, syntax coloring and other
-- functionality.

vim.cmd('filetype indent plugin on')
vim.cmd('syntax on')

vim.cmd('source ~/.config/nvim/init-vimscript.vim')

require('wassim')
