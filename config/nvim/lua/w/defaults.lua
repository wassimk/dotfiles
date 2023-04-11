--
-- defaults
--

vim.opt.complete = vim.opt.complete + 'kspell'
vim.opt.confirm = true -- prompt for some commands like save
vim.opt.cursorline = true -- highlight current line
vim.opt.hidden = true -- don't hide unmodified buffers
vim.opt.inccommand = 'nosplit' -- live highlight of substitutions
vim.opt.number = true -- display line numbers beside buffer
vim.opt.relativenumber = true -- show line numbers relative to cursor position
vim.opt.scrolloff = 4 -- keep at least 4 lines below cursor
vim.opt.shortmess = vim.opt.shortmess + 'a' -- some sane display defaults
vim.opt.signcolumn = 'yes' -- always show sign column to avoid visual change
vim.opt.splitbelow = true -- new horizontal split below
vim.opt.splitright = true -- new vertical splits to the right
vim.opt.swapfile = false -- don't create useless swap files
vim.opt.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal
vim.opt.undofile = true -- allow undo even after closing a file
vim.opt.winwidth = 100 -- set minimum width of current window
vim.opt.spelloptions:append('camel') -- spell check camelCase words
vim.g.qf_disable_statusline = true -- we'll set a custom statusline for quickfix

-- preferred default tabs/spaces
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

if vim.fn.executable('rg') == 1 then
  -- use rg for grep
  vim.opt.grepprg = 'rg -H --no-heading --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m,%f'

  -- use rg for ack
  vim.g.ackprg = 'rg --vimgrep'
end

-- make netrw use the system's default file/url browser
vim.g.netrw_browsex_viewer = 'open'
