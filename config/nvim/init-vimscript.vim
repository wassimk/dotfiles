" Make test commands execute using dispatch.vim Start
function! DispatchStartStrategy(cmd)
  execute 'Start -title=tests -wait=error ' . a:cmd
endfunction

let g:test#custom_strategies = {'dispatch_start': function('DispatchStartStrategy')}
let g:test#strategy = 'dispatch_start'

""""
" statusline via vim-airline plugin
""""
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
      \'c': 'C',
      \'i': 'I',
      \'ic': 'IC',
      \'n': 'N',
      \'v': 'V',
      \'V': 'V',
\}

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.colnr = " 𝚌 "
let g:airline_symbols.linenr = "ℓ "
let g:airline_section_x = '%{airline#util#prepend("", 0)}'
let g:airline_section_y = ''
let g:airline_section_z = "%{g:airline_symbols.linenr}%l/%L%{g:airline_symbols.colnr}%v"

" Update the tmuxline config file automatically
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmuxline.conf"
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : '#I #W #F',
      \'z'    : '#($(echo hostname -s) | tr "[:upper:]" "[:lower:]")',
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
let g:ale_linters_explicit = 1

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
let g:NERDTreeMinimalUI = 1
let g:NERDTreeStatusline = ""

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


" Use vim built in
let g:ale_disable_lsp = 1

" let g:completion_auto_change_source = 1

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
