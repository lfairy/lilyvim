" LilyPond indent file
" Language:     LilyPond
" Maintainer:   Heikki Junes <hjunes@cc.hut.fi>, Chris Wong <lambda.fairy@gmail.com>
" Last Change:  2012 Dec 29
"
" Installed As:	vim/indent/lilypond.vim

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetLilyPondIndent()
setlocal indentkeys=o,O,},>>,!^F

" Only define the function once.
if exists("*GetLilyPondIndent")
  finish
endif

function GetLilyPondIndent()
  if v:lnum == 1
    return 0
  endif

  "Find a non-blank line above the current line.
  let prev = prevnonblank(v:lnum - 1)
  let prevline = getline(prev)
  "Check if a block was started: '{' or '<<' is the last non-blank character of the previous line.
  if prevline =~ '^.*\({\|<<\)\s*$'
    return indent(prev) + &sw
  elseif prevline =~ '^.*\(}\|>>\)\s*$'
    return indent(prev) - &sw
  else
    return indent(prev)
  endif
endfunction
