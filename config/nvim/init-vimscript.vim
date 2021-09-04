""""
" vim-plug - https://github.com/junegunn/vim-plug
""""
call plug#begin()

  " Code / Git
  Plug 'dense-analysis/ale'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-dispatch'
  Plug 'windwp/nvim-autopairs'
  Plug 'janko-m/vim-test'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-nvim-lua'
  Plug 'hrsh7th/cmp-path'
  Plug 'f3fora/cmp-spell'
  Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'

  " JavaScript
  Plug 'pangloss/vim-javascript'
  Plug 'mxw/vim-jsx'
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'maxmellon/vim-jsx-pretty'

  " Ruby / Rails
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'

  " Vim Text Objects and Motions
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'wellle/targets.vim'
  Plug 'kana/vim-textobj-user'
  Plug 'kana/vim-textobj-line'
  Plug 'kana/vim-textobj-entire'
  Plug 'kana/vim-textobj-indent'
  Plug 'christoomey/vim-sort-motion'
  Plug 'junegunn/vim-easy-align'
  Plug 'tpope/vim-unimpaired'

  " Files And Search
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'JazzCore/ctrlp-cmatcher'
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'wincent/loupe'
  Plug 'wincent/ferret'
  Plug 'wincent/scalpel'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Pretty much automatic
  Plug 'wincent/vim-clipper'
  Plug 'Yggdroot/indentLine'
  Plug 'tpope/vim-repeat'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'editorconfig/editorconfig-vim'

  " Theme / Status Line / Tmux / Pretty Terminal / Vim
  Plug 'joshdick/onedark.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'edkolev/tmuxline.vim'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'wincent/terminus'
  Plug 'milkypostman/vim-togglelist'

call plug#end()

" Make test commands execute using dispatch.vim Start
function! DispatchStartStrategy(cmd)
  execute 'Start -title=tests -wait=error ' . a:cmd
endfunction

let g:test#custom_strategies = {'dispatch_start': function('DispatchStartStrategy')}
let g:test#strategy = 'dispatch_start'

" Theme and terminal color support
set cursorline
syntax on
colorscheme onedark
let g:airline_theme='onedark'
if (has("termguicolors"))
  set termguicolors
endif

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
      \'z'    : '#h',
      \ 'options': { 'status-justify': 'left' }
\}

"""
" Ale Code Linting
"""
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0 " opening file
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 0
let g:ale_set_highlights = 0

let g:ale_sign_warning = '-'
let g:ale_sign_error = '●'
let g:airline#extensions#ale#enabled = 1

" Format of messages
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Enable specific linters
let g:ale_linters = { 'javascript': ['eslint'], 'ruby': ['prettier', 'rubocop', 'standard'], 'typescript': ['eslint']}

" Use bundle exec version
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_ruby_rubocop_options = '--display-cop-names --parallel'

" Use autofix
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'ruby': ['prettier'],
\}

" NERDTree Settings
let NERDTreeMinimalUI = 1

" The Silver Searcher
" brew install the_silver_searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag for ack
  let g:ackprg = 'ag --vimgrep'

  " Configure CtrlP
  let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_max_files = 0
  let g:ctrlp_use_caching = 0
endif

" Prefer `ag` over `rg` with Ferret
let g:FerretExecutable='ag,rg'

" Align GitHub-flavored Markdown tables with vim-easy-align
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

augroup quickfix
  autocmd!
  autocmd FileType qf setlocal wrap
augroup END

" Use system clipboard always
set clipboard=unnamed

" Enable built-in matchit plugin
runtime macros/matchit.vim

filetype indent plugin on

set nocompatible                " This is Vim not Vi
set laststatus=2                " Always show status line
set number                      " Display line numbers beside buffer
set lazyredraw                  " Don't update while executing macros
set backspace=indent,eol,start  " Sane backspace behavior
set scrolloff=4                 " Keep at least 4 lines below cursor
set noswapfile                  " Don't know why but I don't need it
set tabstop=2                   " Two spaces per tab as default
set shiftwidth=2                "     then override with per filteype
set softtabstop=2               "     specific settings via autocmd
set expandtab                   " Convert <tab> to spaces (2 or 4)
" set secure                      " Limit what modelines and autocmds can do
set relativenumber              " Show line numbers relative to cursor position
set autoread                    " Used when edting same file with vim, twice
set autoindent                  " Always auto-indent
set showcmd                     " Show when leader is hit
set colorcolumn=100             " Show colored column at 100 chars"
set wildmenu                    " Command line auto-complete feature
set ruler                       " The status line feature of cursor position
set smarttab                    " Handle tabs, spaces or not smartly
set cursorline                  " Highlight current line
set winwidth=100                " Set minimum width of current window
"set winheight=5                 " Windows all start at 5 lines tall
"set winminheight=5              " Windows always 5 lines tall
"set winheight=999               " Current window full height but preserve 5 lines for others
set hidden                      " Hide unsaved buffers
set complete-=i                 " Not sure, from sensible
set display+=lastline           " Not sure, from sensible
set scrolloff=1                 " Not sure, from sensible
set sidescrolloff=5             " Not sure, from sensible
set splitright                  " New veritcle splits to the right
set splitbelow                  " New horizontal split below
set inccommand=nosplit          " Live highlight of substitutions

" Highlight on yank
au TextYankPost * silent! lua vim.highlight.on_yank {timeout=750}

" Wrap markdown files at 100 characters
au BufRead,BufNewFile *.md setlocal textwidth=100

" Spell check
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell | setlocal textwidth=72
set complete+=kspell

" Use vim built in
let g:ale_disable_lsp = 1

""""
" completion
""""

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

let g:completion_trigger_on_delete = 1
let g:completion_confirm_key = "\<C-y>"
" let g:completion_auto_change_source = 1

" Avoid showing message extra message when using completion
" set shortmess+=c

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

" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR> " t Ctrl+n
nmap <silent> t<C-f> :TestFile<CR>    " t Ctrl+f
nmap <silent> t<C-a> :TestSuite<CR>   " t Ctrl+a
nmap <silent> t<C-l> :TestLast<CR>    " t Ctrl+l
nmap <silent> t<C-g> :TestVisit<CR>   " t Ctrl+g

" Edit todo and notes
map <leader>nw :e! ~/Dropbox/docs/todo-work.md<cr>
map <leader>np :e! ~/Dropbox/docs/todo-personal.md<cr>
map <leader>nn :e! ~/Dropbox/docs/notes.md<cr>
map <leader>nh :e! ~/Dropbox/docs/tiny-habits.md<cr>

" Auto-indent the whole file
map <leader>fi mmgg=G`m<CR>
