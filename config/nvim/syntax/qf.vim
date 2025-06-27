" qf.vim
" syntax for quickfix/loclist
" TODO: convert to lua and reference signs in w.diagnostic and lspkind symbols
"

if exists('b:current_syntax')
  finish
endif

" determine what to highlight
syn match qfFileName /^[^│]*/ nextgroup=qfSeparatorLeft
syn match qfSeparatorLeft /│/ contained nextgroup=qfLineNr
syn match qfLineNr /[^│]*/ contained nextgroup=qfSeparatorRight
syn match qfSeparatorRight '│' contained nextgroup=qfError,qfWarning,qfInfo,qfNote,qfLspText,qfLspMethod,qfLspFunction,qfLspConstructor,qfLspField,qfLspVariable,qfLspClass,qfLspInterface,qfLspModule,qfLspProperty,qfLspUnit,qfLspValue,qfLspEnum,qfLspKeyword,qfLspSnippet,qfLspColor,qfLspFile,qfLspReference,qfLspFolder,qfLspEnumMember,qfLspConstant,qfLspStruct,qfLspEvent,qfLspOperator,qfLspTypeParameter

syn match qfError /  / contained
syn match qfWarning /  / contained
syn match qfInfo /  / contained
syn match qfNote /  / contained

syn match qfLspText /  / contained
syn match qfLspMethod /  / contained
syn match qfLspFunction /  / contained
syn match qfLspConstructor /  / contained
syn match qfLspField /  / contained
syn match qfLspVariable /  / contained
syn match qfLspClass /  / contained
syn match qfLspInterface /  / contained
syn match qfLspModule /  / contained
syn match qfLspProperty /  / contained
syn match qfLspUnit /  / contained
syn match qfLspValue /  / contained
syn match qfLspEnum /  / contained
syn match qfLspKeyword /  / contained
syn match qfLspSnippet /  / contained
syn match qfLspColor /  / contained
syn match qfLspFile /  / contained
syn match qfLspReference /  / contained
syn match qfLspFolder /  / contained
syn match qfLspEnumMember /  / contained
syn match qfLspConstant /  / contained
syn match qfLspStruct /  / contained
syn match qfLspEvent /  / contained
syn match qfLspOperator /  / contained
syn match qfLspTypeParameter /  / contained

" apply highlighting
hi def link qfFileName Directory
hi def link qfSeparatorLeft Delimiter
hi def link qfSeparatorRight Delimiter
hi def link qfLineNr LineNr

hi def link qfError DiagnosticSignError
hi def link qfWarning DiagnosticSignWarn
hi def link qfInfo DiagnosticSignInfo
hi def link qfNote DiagnosticSignHint

hi def link qfLspText BlinkCmpKindText
hi def link qfLspMethod BlinkCmpKindMethod
hi def link qfLspFunction BlinkCmpKindFunction
hi def link qfLspConstructor BlinkCmpKindConstructor
hi def link qfLspField BlinkCmpKindField
hi def link qfLspVariable BlinkCmpKindVariable
hi def link qfLspClass BlinkCmpKindClass
hi def link qfLspInterface BlinkCmpKindInterface
hi def link qfLspModule BlinkCmpKindModule
hi def link qfLspProperty BlinkCmpKindProperty
hi def link qfLspUnit BlinkCmpKindUnit
hi def link qfLspValue BlinkCmpKindValue
hi def link qfLspEnum BlinkCmpKindEnum
hi def link qfLspKeyword BlinkCmpKindKeyword
hi def link qfLspSnippet BlinkCmpKindSnippet
hi def link qfLspColor BlinkCmpKindColor
hi def link qfLspFile BlinkCmpKindFile
hi def link qfLspReference BlinkCmpKindReference
hi def link qfLspFolder BlinkCmpKindFolder
hi def link qfLspEnumMember BlinkCmpKindEnumMember
hi def link qfLspConstant BlinkCmpKindConstant
hi def link qfLspStruct BlinkCmpKindStruct
hi def link qfLspEvent BlinkCmpKindEvent
hi def link qfLspOperator BlinkCmpKindOperator
hi def link qfLspTypeParameter BlinkCmpKindTypeParameter

let b:current_syntax = 'qf'
