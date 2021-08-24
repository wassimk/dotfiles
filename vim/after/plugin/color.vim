""""
" Automatic Theme Apply
""""

" This function runs anytime Vim is started or focus gained, it
" matches the color scheme of the terminal that uses base16-shell
" See zshrc for that configuration under the colors source
" - Requires the base16-vim plugin"

function s:CheckColorScheme()
  let s:config_file = expand('~/.vim/.base16')

  if filereadable(s:config_file)
    let s:config = readfile(s:config_file, '', 2)

    if s:config[1] =~# '^dark\|light$'
      execute 'set background=' . s:config[1]
    else
      echoerr 'Bad background ' . s:config[1] . ' in ' . s:config_file
    endif

    if filereadable(expand('~/.vim/plugged/base16-vim/colors/base16-' . s:config[0] . '-' . s:config[1] . '.vim'))
      execute 'color base16-' . s:config[0] . '-' . s:config[1]
    elseif filereadable(expand('~/.vim/plugged/base16-vim/colors/base16-' . s:config[0] . '.vim'))
      execute 'color base16-' . s:config[0]
    else
      echoerr 'Bad scheme ' . s:config[0] . ' in ' . s:config_file
    endif
  else " default
    set background=dark
    color base16-default
  endif

  doautocmd ColorScheme
endfunction

" Disable this tool while switching to a linux/terminal based development environment
" if v:progname !=# 'vi'
"   if has('autocmd')
"     augroup WamAutocolor
"       autocmd!
"       autocmd FocusGained * call s:CheckColorScheme()
"     augroup END
"   endif

"   call s:CheckColorScheme()
" endif
