""""
" vim-plug - https://github.com/junegunn/vim-plug
""""
call plug#begin()
  " Code / Git
  Plug 'scrooloose/syntastic'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'

  " Ruby / Rails
  Plug 'vim-ruby/vim-ruby'
  Plug 'thoughtbot/vim-rspec'
  Plug 'tpope/vim-rails'

  " Files and Search
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'mileszs/ack.vim'

  " Pretty much automatic
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'

  " Theme / Status Line / Tmux
  Plug 'chriskempson/base16-vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'edkolev/tmuxline.vim'
  Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" vim-airline theme settings
set t_cO=256
let g:base16colorspace=256
let g:airline_powerline_fonts=1

" vim-airline applies its theme to tmuxline plugin
" these are preferred defaults, info at https://github.com/edkolev/tmuxline.vim
" auto-generated via ~/.vim/after/plugin/color.vim"
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
set colorcolumn=97              " Show colored column at 97 chars"
set ruler                       " Not sure, from sensible
set complete-=i                 " Not sure, from sensible
set smarttab                    " Not sure, from sensible
set display+=lastline           " Not sure, from sensible
set scrolloff=1                 " Not sure, from sensible
set sidescrolloff=5             " Not sure, from sensible

" Break those bad habits
" NO more arrow keys!
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <up> <nop>
vnoremap <up> <nop>
inoremap <down> <nop>
vnoremap <down> <nop>
inoremap <left> <nop>
vnoremap <right> <nop>
vnoremap <left> <nop>
inoremap <right> <nop>

""""
" Custom Key Mappings
""""
imap jj <esc>

" bind K to grep the word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" NERDTree Toggle
map <silent> <C-n> :NERDTreeToggle<CR>

""""
" Custom Leader Mappings
""""
let mapleader = "\<Space>"

" Split edit vimrc
nmap <leader>ev :sp $MYVIMRC<cr>

" Source (reload) vimrc
nmap <leader>sv :source $MYVIMRC<cr>
