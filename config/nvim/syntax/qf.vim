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

hi def link qfLspText CmpItemKindText
hi def link qfLspMethod CmpItemKindMethod
hi def link qfLspFunction CmpItemKindFunction
hi def link qfLspConstructor CmpItemKindConstructor
hi def link qfLspField CmpItemKindField
hi def link qfLspVariable CmpItemKindVariable
hi def link qfLspClass CmpItemKindClass
hi def link qfLspInterface CmpItemKindInterface
hi def link qfLspModule CmpItemKindModule
hi def link qfLspProperty CmpItemKindProperty
hi def link qfLspUnit CmpItemKindUnit
hi def link qfLspValue CmpItemKindValue
hi def link qfLspEnum CmpItemKindEnum
hi def link qfLspKeyword CmpItemKindKeyword
hi def link qfLspSnippet CmpItemKindSnippet
hi def link qfLspColor CmpItemKindColor
hi def link qfLspFile CmpItemKindFile
hi def link qfLspReference CmpItemKindReference
hi def link qfLspFolder CmpItemKindFolder
hi def link qfLspEnumMember CmpItemKindEnumMember
hi def link qfLspConstant CmpItemKindConstant
hi def link qfLspStruct CmpItemKindStruct
hi def link qfLspEvent CmpItemKindEvent
hi def link qfLspOperator CmpItemKindOperator
hi def link qfLspTypeParameter CmpItemKindTypeParameter

let b:current_syntax = 'qf'
