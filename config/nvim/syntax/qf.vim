" qf.vim
" syntax for quickfix/loclist
" TODO: convert to lua and reference signs in w.diagnostic
"

if exists('b:current_syntax')
  finish
endif

syn match qfFileName /^[^│]*/ nextgroup=qfSeparatorLeft
syn match qfSeparatorLeft /│/ contained nextgroup=qfLineNr
syn match qfLineNr /[^│]*/ contained nextgroup=qfSeparatorRight
syn match qfSeparatorRight '│' contained nextgroup=qfError,qfWarning,qfInfo,qfNote
syn match qfError /  / contained
syn match qfWarning /  / contained
syn match qfInfo /  / contained
syn match qfNote /  / contained

hi def link qfFileName Directory
hi def link qfSeparatorLeft Delimiter
hi def link qfSeparatorRight Delimiter
hi def link qfLineNr LineNr

hi def link qfError DiagnosticSignError
hi def link qfWarning DiagnosticSignWarn
hi def link qfInfo DiagnosticSignInfo
hi def link qfNote DiagnosticSignHint

let b:current_syntax = 'qf'
