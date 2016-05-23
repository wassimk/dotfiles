function s:CheckColorScheme()

  let g:base16colorspace=256
  let g:airline_powerline_fonts=1

  let s:config_file = expand('~/.vim/.base16')

  if filereadable(s:config_file)
    let s:config = readfile(s:config_file, '', 2)

    if s:config[1] =~# '^dark\|light$'
      execute 'set background=' . s:config[1]
    else
      echoerr 'Bad background ' . s:config[1] . ' in ' . s:config_file
    endif

    if filereadable(expand('~/.vim/plugged/base16-vim/colors/base16-' . s:config[0] . '.vim'))
      execute 'color base16-' . s:config[0]

      let g:airline_theme='base16_' . s:config[0]

      "Write tmux powerline config so it works without vim next load
      :TmuxlineSnapshot! ~/.tmuxline.conf
    else
      echoerr 'Bad scheme ' . s:config[0] . ' in ' . s:config_file
    endif
  else " default
    set background=dark
    color base16-tomorrow
    let g:airline_theme='base16_tomorrow'
  endif

  " Allow for overrides:
  " - `statusline.vim` will re-set User1, User2 etc.
  " - `after/plugin/loupe.vim` will override Search.
  doautocmd ColorScheme
endfunction

if v:progname !=# 'vi'
  call s:CheckColorScheme()
endif
