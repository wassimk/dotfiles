--
-- defaults
--

vim.opt.complete = vim.opt.complete + 'kspell'
vim.opt.confirm = true -- prompt for some commands like save
vim.opt.cursorline = true -- highlight current line
vim.opt.hidden = true -- don't hide unmodified buffers
vim.opt.hlsearch = true -- highlight search results
vim.opt.ignorecase = true -- case-insensitive search
vim.opt.smartcase = true -- case-sensitive when uppercase is used
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
vim.opt.winborder = 'rounded' -- set window borders to rounded
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

-- typo corrections
vim.cmd.iabbrev('precense presence')
vim.cmd.iabbrev('desparate desperate')
vim.cmd.iabbrev('desparates desperates')
vim.cmd.iabbrev('desparated desperated')
vim.cmd.iabbrev('desparating desperating')
vim.cmd.iabbrev('desparately desperately')
vim.cmd.iabbrev('desparation desperation')
vim.cmd.iabbrev('desparations desperations')
vim.cmd.iabbrev('desparator desperator')
vim.cmd.iabbrev('seperate separate')
vim.cmd.iabbrev('seperates separates')
vim.cmd.iabbrev('seperated separated')
vim.cmd.iabbrev('seperating separating')
vim.cmd.iabbrev('seperately separately')
vim.cmd.iabbrev('seperation separation')
vim.cmd.iabbrev('seperations separations')
vim.cmd.iabbrev('seperator separator')
vim.cmd.iabbrev('nofity notify')
vim.cmd.iabbrev('beacuse because')
vim.cmd.iabbrev('teste test')
vim.cmd.iabbrev('acknowledgement acknowledgment')

-- disable providers i don't use
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
