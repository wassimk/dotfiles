--
-- defaults
--

local g = vim.g
local opt = vim.opt

opt.complete = opt.complete + 'kspell'
opt.confirm = true -- prompt for some commands like save
opt.cursorline = true -- highlight current line
opt.hidden = false -- don't hide unmodified buffers
opt.inccommand = 'nosplit' -- live highlight of substitutions
opt.number = true -- display line numbers beside buffer
opt.relativenumber = true -- show line numbers relative to cursor position
opt.scrolloff = 4 -- keep at least 4 lines below cursor
opt.shortmess = opt.shortmess + 'a' -- some sane display defaults
opt.signcolumn = 'yes' -- always show sign column to avoid visual change
opt.splitbelow = true -- new horizontal split below
opt.splitright = true -- new vertical splits to the right
opt.swapfile = false -- don't create useless swap files
opt.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal
opt.undofile = true -- allow undo even after closing a file
opt.winwidth = 100 -- set minimum width of current window

-- preferred default tabs/spaces
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

if vim.fn.executable('rg') == 1 then
  -- use rg for grep
  opt.grepprg = 'rg -H --no-heading --vimgrep'
  opt.grepformat = '%f:%l:%c:%m,%f'

  -- use rg for ack
  g.ackprg = 'rg --vimgrep'
end
