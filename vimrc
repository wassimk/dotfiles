# use vim as the visual editor
export VISUAL='vim'
export EDITOR=$VISUAL

""""
" vim-plug - https://github.com/junegunn/vim-plug
""""
call plug#begin()
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'thoughtbot/vim-rspec'
  Plug 'scrooloose/nerdtree'
  Plug 'nanotech/jellybeans.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'edkolev/tmuxline.vim'
  Plug 'scrooloose/syntastic'
call plug#end()

" The Silver Searching command, use it for CtrlP
" Turn off CtrlP caching because it's now so much faster
" Install first from https://github.com/ggreer/the_silver_searcher
let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
let g:ctrlp_use_caching = 0

" Use the color scheme from Plugin
colorscheme jellybeans

" vim-airline theme for fancy status bar
let g:airline_theme='jellybeans'
let g:airline_powerline_fonts=1 " install fonts first, in the repo
" vim-arline applies its theme to tmuxline plugin
" these are preferred defaults, info at https://github.com/edkolev/tmuxline.vim
" generate a new tmuxline.conf with any change via vim with :TmuxlineSnapshot! ~/.tmuxline.conf
" make sure and change terminal font to one of the powerline fonts
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : '#I #W #F',
      \'x'    : '#(battery -t)',
      \'y'    : ['%a, %b %d', '%I:%M %p'],
      \'z'    : '#h',
      \ 'options': { 'status-justify': 'left' }
\}

" Syntax Checking with syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_ruby_checkers = ['rubocop', 'mri']

let mapleader = ","
imap jj <esc>

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
set secure                      " Limit what modelines and autocmds can do
set relativenumber              " Show line numbers relative to cursor position
set autoread                    " Used when edting same file with vim, twice
set autoindent                  " Always auto-indent
set ruler                       " Not sure, from sensible
set complete-=i                 " Not sure, from sensible
set smarttab                    " Not sure, from sensible
set display+=lastline           " Not sure, from sensible
set scrolloff=1                 " Not sure, from sensible
set sidescrolloff=5             " Not sure, from sensible
