" viki.vim -- the viki ftplugin
" @Author:      Thomas Link (samul AT web.de)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     12-J�n-2004.
" @Last Change: 28-J�n-2004.
" @Revision: 7

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let b:vikiCommentStart = "%"
let b:vikiCommentEnd   = ""

exe "setlocal commentstring=". b:vikiCommentStart ."%s". b:vikiCommentEnd
exe "setlocal comments=:". b:vikiCommentStart

setlocal foldmethod=expr
setlocal foldexpr=VikiFoldLevel(v:lnum)

if !hasmapto(":VikiFind")
    nnoremap <buffer> <c-tab>   :VikiFindNext<cr>
    nnoremap <buffer> <c-s-tab> :VikiFindPrev<cr>
endif

let b:vikiEnabled = 2

