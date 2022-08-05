local api = vim.api
local g = vim.g
local opt = vim.opt

opt.cursorline = true -- highlight current line
opt.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal
-- opt.nocompatible = true -- This is Vim not Vi
opt.laststatus = 2 -- Always show status line
opt.number = true -- Display line numbers beside buffer
opt.lazyredraw = true -- Don't update while executing macros
opt.backspace = 'indent,eol,start' -- Sane backspace behavior
opt.scrolloff = 4 -- Keep at least 4 lines below cursor
opt.swapfile = false -- Don't create useless swap files
opt.tabstop = 2 -- Two spaces per tab as default
opt.shiftwidth = 2 -- then override with per filteype
opt.softtabstop = 2 -- specific settings via autocmd
opt.expandtab = true -- Convert <tab> to spaces (2 or 4)
opt.relativenumber = true -- Show line numbers relative to cursor position
opt.autoread = true -- Used when edting same file with vim, twice
opt.autoindent = true -- Always auto-indent
opt.showcmd = true -- Show when leader is hit
-- opt.colorcolumn = 100 -- Show colored column at 100 chars"
opt.wildmenu = true -- Command line auto-complete feature
opt.ruler = true -- The status line feature of cursor position
opt.smarttab = true -- Handle tabs, spaces or not smartly
opt.winwidth = 100 -- Set minimum width of current window
opt.hidden = false -- Don't hide unmodified buffers, error out
opt.confirm = true -- Don't error when existing without saving, ask to save
opt.complete = opt.complete - 'i' -- Not sure, from sensible
opt.display = opt.display + 'lastline' -- Not sure, from sensible
opt.scrolloff = 1 -- Not sure, from sensible
opt.sidescrolloff = 5 -- Not sure, from sensible
opt.splitright = true -- New veritcle splits to the right
opt.splitbelow = true -- New horizontal split below
opt.inccommand = 'nosplit' -- Live highlight of substitutions
opt.complete = opt.complete + 'kspell'
opt.shortmess = opt.shortmess + 'a' -- Some sane display defaults

-- allow undo even after closing a file
opt.undofile = true
opt.undodir = os.getenv('HOME') .. '/.config/nvim/undo'

-- use only the system clipboard
opt.clipboard = opt.clipboard + 'unnamedplus'
