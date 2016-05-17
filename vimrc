
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
  Plug 'thoughtbot/vim-rspec'
  Plug 'scrooloose/nerdtree'
  Plug 'nanotech/jellybeans.vim'
call plug#end()

" The Silver Searching command, use it for CtrlP
" Turn off CtrlP caching because it's now so much faster
" Install first from https://github.com/ggreer/the_silver_searcher
let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
let g:ctrlp_use_caching = 0

" Use the color scheme from Plugin
colorscheme jellybeans

let mapleader = ","
