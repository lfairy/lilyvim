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
    " Check if the first character from the previous line is within
    " a `lilyScheme' region, and if so, use lisp-style indentation
    " for the current line.
    "
    " TODO:
    "   - Only works in version 7.1.215 or later, though it should
    "     silently fail in older versions.
    "   - We should support `lilyScheme' regions that begin in the
    "     middle of the line, too.
    for id in synstack(lnum, 1)
        if synIDattr(id, "name") == "lilyScheme"
            let lispind = lispindent(v:lnum)
        endif
    endfor
    if exists('lispind')
        return lispind
    endif

    if v:lnum == 1
        return 0
    endif

    " Find a non-blank line above the current line.
    let prev = prevnonblank(v:lnum - 1)
    let prevline = getline(prev)

    " Find the number of opening and closing characters.
    let opens = strlen(substitute(prevline, '\({\|<<\)\@!.', '', 'g'))
    let closes = strlen(substitute(prevline, '\(}\|>>\)\@!.', '', 'g'))

    " If they are not balanced, indent accordingly.
    if opens > closes
        return indent(prev) + &sw
    elseif opens < closes
        return indent(prev) - &sw
    else
        return indent(prev)
    endif
endfunction
