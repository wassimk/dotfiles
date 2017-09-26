""""
" vim-plug - https://github.com/junegunn/vim-plug
""""
call plug#begin()

  " Code / Git
  Plug 'w0rp/ale'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-fugitive'
  Plug 'christoomey/vim-conflicted'
  Plug 'jiangmiao/auto-pairs'
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-shell'
  Plug 'xolox/vim-easytags'

  " JavaScript
  Plug 'pangloss/vim-javascript'
  Plug 'mxw/vim-jsx'
  " Plug 'flowtype/vim-flow'

  " Miscellaneous
  Plug 'junegunn/vim-easy-align'
  Plug 'keith/tmux.vim'

  " Ruby / Rails
  Plug 'vim-ruby/vim-ruby'
  Plug 'thoughtbot/vim-rspec'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-bundler'
  Plug 'tpope/vim-rake'

  " Vim Text Objects and Motions
  Plug 'kana/vim-textobj-user'
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'kana/vim-textobj-line'
  Plug 'kana/vim-textobj-entire'
  Plug 'kana/vim-textobj-indent'
  Plug 'christoomey/vim-system-copy'
  Plug 'christoomey/vim-sort-motion'

  " Files And Search
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'wincent/ferret'
  Plug 'tpope/vim-unimpaired'
  Plug 'wincent/loupe'
  Plug 'milkypostman/vim-togglelist'
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'

  " Pretty much automatic
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'ntpeters/vim-better-whitespace'

  " Theme / Status Line / Tmux / Pretty Terminal
  Plug 'chriskempson/base16-vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'edkolev/tmuxline.vim'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'christoomey/vim-tmux-runner'
  Plug 'wincent/terminus'

call plug#end()

" Ferret Plugin
" Don't map shortcuts
let g:FerretQFMap=0
let g:FerretMap=1

" Run vim-rspec commands with dispatch
let g:rspec_command = "!clear && rspec {spec}"

" Terminal color support for base-16 themes
set t_cO=256
let g:base16colorspace=256
let g:airline_powerline_fonts=1

" vim-airline applies its theme to tmuxline plugin
" these are preferred defaults, info at https://github.com/edkolev/tmuxline.vim
" make sure and change terminal font to one of the powerline fonts

" Automatically change the theme?
let g:airline#extensions#tmuxline#enabled = 1

" Update config file automatically
let airline#extensions#tmuxline#snapshot_file = "~/.tmuxline.conf"
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : '#I #W #F',
      \'x'    : '#(battery -t)',
      \'y'    : ['%a, %b %d', '%I:%M %p'],
      \'z'    : '',
      \ 'options': { 'status-justify': 'left' }
\}

"""
" Ale Code Linting
"""
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1 " opening file
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 1

let g:ale_sign_warning = '-'
let g:ale_sign_error = '●'
let g:airline#extensions#ale#enabled = 1

" Format of messages
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" EasyTags
let g:easytags_suppress_report = 1
let g:easytags_async = 1

" NERDTree Settings
let NERDTreeMinimalUI = 1

" The Silver Searcher
" brew install the_silver_searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag for ack
  let g:ackprg = 'ag --vimgrep'

  " Use ag for CtrlP and turn off caching because it's now so much faster
  let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" Align GitHub-flavored Markdown tables with vim-easy-align
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" Uses ntpeters/vim-better-whitespace plugin
autocmd BufEnter * EnableStripWhitespaceOnSave

augroup quickfix
  autocmd!
  autocmd FileType qf setlocal wrap
augroup END

" Use system clipboard always
set clipboard=unnamed

" Enable built-in matchit plugin
runtime macros/matchit.vim

filetype indent plugin on
syntax on

set nocompatible                " This is Vim not Vi
set laststatus=2                " Always show status line
set number                      " Display line numbers beside buffer
set lazyredraw                  " Don't update while executing macros
set backspace=indent,eol,start  " Sane backspace behavior
set history=500                 " Remember last 500 commands
set scrolloff=4                 " Keep at least 4 lines below cursor
set noswapfile                  " Don't know why but I don't need it
set expandtab                   " Convert <tab> to spaces (2 or 4)
set tabstop=2                   " Two spaces per tab as default
set shiftwidth=2                "     then override with per filteype
set softtabstop=2               "     specific settings via autocmd
" set secure                      " Limit what modelines and autocmds can do
set relativenumber              " Show line numbers relative to cursor position
set autoread                    " Used when edting same file with vim, twice
set autoindent                  " Always auto-indent
set showcmd                     " Show when leader is hit
set colorcolumn=100             " Show colored column at 100 chars"
set hlsearch                    " Highlight /search results
set incsearch                   " Incrementally highlight search while typing
set ignorecase                  " Case insensitive searching
set smartcase                   " Override ignorecase if pattern has upcase
set wildmenu                    " Command line auto-complete feature
set ruler                       " The status line feature of cursor position
set smarttab                    " Handle tabs, spaces or not smartly
set cursorline                  " Highlight current line
set winwidth=100                " Set minimum width of current window
"set winheight=5                 " Windows all start at 5 lines tall
"set winminheight=5              " Windows always 5 lines tall
"set winheight=999               " Current window full height but preserve 5 lines for others
"set hidden                      " Hide unsaved buffers
set complete-=i                 " Not sure, from sensible
set display+=lastline           " Not sure, from sensible
set scrolloff=1                 " Not sure, from sensible
set sidescrolloff=5             " Not sure, from sensible
set splitright                  " New veritcle splits to the right
set splitbelow                  " New horizontal split below

" Wrap markdown files at 100 characters
au BufRead,BufNewFile *.md setlocal textwidth=100

""""
" Autocmd's
""""
if has('autocmd')
  augroup WamAutocmds
    autocmd!

    autocmd VimResized * execute "normal! \<c-w>="
 augroup END
endif

""""
" Custom Key Mappings
""""
inoremap jj <esc>

" NERDTree Toggle
map <silent> <C-n> :NERDTreeToggle<CR>

" CtrlP .gitignore Search
map <silent> <C-i> :CtrlPMixed<CR>

" Custom Leader Mappings
""""
let mapleader = "\<Space>"

" Split edit vimrc and zshrc
nmap <leader>ev :vsplit $MYVIMRC<cr>
nmap <leader>ez :vsplit ~/.zshrc<cr>
nmap <leader>et :vsplit ~/.tmux.conf<cr>

" Source (reload) vimrc
nmap <leader>sv :source $MYVIMRC<cr>

" RSpec.vim mappings
map <leader>tf :call RunCurrentSpecFile()<CR>
map <leader>tn :call RunNearestSpec()<CR>
map <leader>tl :call RunLastSpec()<CR>
map <leader>ts :call RunAllSpecs()<CR>

" Edit todo and notes
map <leader>nw :e! ~/Dropbox/docs/todo-work.md<cr>
map <leader>np :e! ~/Dropbox/docs/todo-personal.md<cr>
map <leader>nn :e! ~/Dropbox/docs/notes.md<cr>
map <leader>nh :e! ~/Dropbox/docs/tiny-habits.md<cr>

" Auto-indent the whole file
map <leader>fi mmgg=G`m<CR>

" Yank whole file
map <leader>fy mmggyG`m<CR>

" Vim tmux runner mappings
map <leader>rc :VtrSendCommandToRunner<cr>
map <leader>rl :VtrSendLinesToRunner<cr>
map <leader>ro :VtrOpenRunner<cr>
map <leader>rk :VtrKillRunner<cr>
map <leader>rd :VtrDetachRunner<cr>
map <leader>ra :VtrReattachRunner<cr>
map <leader>rf :VtrFlushCommand<cr>
map <leader>rv :VtrSendSelectedToRunner<cr>
