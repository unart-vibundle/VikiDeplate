" viki.vim -- the viki syntax file
" @Author:      Thomas Link (samul AT web.de)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     30-Dez-2003.
" @Last Change: 27-Sep-2004.
" @Revision: 0.424

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" This command sets up buffer variables and adds some basic highlighting.
let b:VikiEnabled = 0
call VikiDispatchOnFamily("VikiMinorMode", -1)
let b:VikiEnabled = 2

syntax sync minlines=50
syntax sync maxlines=200

syn match vikiEscape /\\/ contained containedin=vikiEscapedChar
syn match vikiEscapedChar /\\\_./ contains=vikiEscape,vikiChar

exe "syn match vikiAnchor /^". escape(b:vikiCommentStart, '\/.*^$~[]') .'\?\s*#'. b:vikiAnchorNameRx ."/"
syn match vikiMarkers /\(\([#?!+]\)\2\{2,2}\)/
syn match vikiSymbols /\(--\|!=\|==\+\|\~\~\+\|<-\+>\|<=\+>\|<\~\+>\|<-\+\|-\+>\|<=\+\|=\+>\|<\~\+\|\~\+>\|\.\.\.\)/

syn match vikiBold /\(^\|\W\zs\)\*\(\\\*\|\w\)\{-1,}\*/
syn region vikiContinousBold start=/\(^\|\W\zs\)\*\*[^ 	*]/ end=/\*\*\|\n\{2,}/ skip=/\\\n/

syn match vikiUnderline /\(^\|\W\zs\)_\(\\_\|[^_\s]\)\{-1,}_/
syn region vikiContinousUnderline start=/\(^\|\W\zs\)__[^ 	_]/ end=/__\|\n\{2,}/ skip=/\\\n/

syn match vikiTypewriter /\(^\|\W\zs\)=\(\\=\|\w\)\{-1,}=/
syn region vikiContinousTypewriter start=/\(^\|\W\zs\)==[^ 	=]/ end=/==\|\n\{2,}/ skip=/\\\n/

syn cluster vikiHyperLinks contains=vikiLink,vikiExtendedLink,vikiURL,vikiInexistentLink
syn cluster vikiTextstyles contains=vikiBold,vikiContinousBold,vikiTypewriter,vikiContinousTypewriter,vikiUnderline,vikiContinousUnderline,vikiEscapedChar

" contains=vikiTextstyles,vikiLink,vikiExtendedLink,vikiURL
exe 'syn match vikiComment /^\s*'. escape(b:vikiCommentStart, '\/.*^$~[]') .'.*$/ contains=ALL'

syn region vikiString start=+^\s\+"\|"+ end=+"[.?!]\?\s\+$\|"+ contains=@vikiTextstyles,@vikiHyperLinks

let b:vikiHeadingStart = '*'
exe 'syn region vikiHeading start=/\V\^'. escape(b:vikiHeadingStart, '\') .'\+\s\+/ end=/\n/ contains=@vikiTextstyles,@vikiHyperLinks'

syn match vikiList /^\s\+\([-+*#?@]\|[0-9#]\+\.\|[a-zA-Z?]\.\)\ze\s/
syn match vikiDescription /^\s\+\(\\\n\|.\)\{-1,}\s::\ze\s/ contains=@vikiHyperLinks

syn match vikiTableRowSep /||\?/ contained containedin=vikiTableRow,vikiTableHead
syn region vikiTableHead start=/^\s*|| / skip=/\\\n/ end=/ ||\s*$/ contains=ALLBUT,vikiTableRow,vikiTableHead transparent keepend
syn region vikiTableRow  start=/^\s*| / skip=/\\\n/ end=/ |\s*$/ contains=ALLBUT,vikiTableRow,vikiTableHead transparent keepend

syn region vikiMacro matchgroup=vikiMacroDelim start=/{[^:{}]\+:\?/ end=/}/ transparent

syn match vikiCommand /^\C\s*#\([A-Z]\+\)\>\(\\\n\|.\)*/
syn region vikiRegion matchgroup=vikiMacroDelim 
            \ start=/^\s*#\([A-Z][a-z]*\>\|!!!\).\{-}<<\z(.\+\)$/ end=/^\s*\z1\s*$/ contains=ALL
syn region vikiRegionAlt matchgroup=vikiMacroDelim 
            \ start=/^\s*\z(=\{4,}\)\s*\([A-Z][a-z]*\>\|!!!\).\{-}$/ end=/^\s*\z1\(\s.*\)\?$/ contains=ALL


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_viki_syntax_inits")
  if version < 508
    let did_viki_syntax_inits = 1
    command! -nargs=+ HiLink hi link <args>
  else
    command! -nargs=+ HiLink hi def link <args>
  endif
  
  if &background == "light"
      let s:cm1="Dark"
      let s:cm2="Light"
  else
      let s:cm1="Light"
      let s:cm2="Dark"
  endif

  if exists("g:vikiHeadingFont")
      let s:hdfont = " font=". g:vikiHeadingFont
  else
      let s:hdfont = ""
  endif
  
  if exists("g:vikiTypewriterFont")
      let s:twfont = " font=". g:vikiTypewriterFont
  else
      let s:twfont = ""
  endif
 
  HiLink vikiEscapedChars Normal
  exe "hi vikiEscape ctermfg=". s:cm2 ."grey guifg=". s:cm2 ."grey"
  exe "hi vikiHeading term=bold,underline cterm=bold gui=bold ctermfg=". s:cm1 ."Magenta guifg=".s:cm1."Magenta". s:hdfont
  exe "hi vikiList term=bold cterm=bold gui=bold ctermfg=". s:cm1 ."Cyan guifg=". s:cm1 ."Cyan"
  HiLink vikiDescription vikiList
  
  exe "hi vikiTableRowSep term=bold cterm=bold gui=bold ctermbg=". s:cm2 ."Grey guibg=". s:cm2 ."Grey"
  
  exe "hi vikiSymbols term=bold cterm=bold gui=bold ctermfg=". s:cm1 ."Red guifg=". s:cm1 ."Red"
  exe "hi vikiMarkers term=bold cterm=bold gui=bold ctermfg=". s:cm1 ."Red guifg=". s:cm1 ."Red ctermbg=yellow guibg=yellow"
  hi vikiAnchor term=italic cterm=italic gui=italic ctermfg=grey guifg=grey
  HiLink vikiComment Comment
  HiLink  vikiString String
  hi vikiBold term=bold cterm=bold gui=bold
  HiLink vikiContinousBold vikiBold
  hi vikiUnderline term=underline cterm=underline gui=underline
  HiLink vikiContinousUnderline vikiUnderline
  exe "hi vikiTypewriter term=underline ctermfg=". s:cm1 ."Grey guifg=". s:cm1 ."Grey". s:twfont
  HiLink vikiContinousTypewriter vikiTypewriter
  HiLink vikiMacroHead Statement
  HiLink vikiMacroDelim Identifier
  HiLink vikiCommand Statement
  HiLink vikiRegion Statement
  HiLink vikiRegionAlt Statement
 
  delcommand HiLink
endif

if g:vikiMarkInexistent
    VikiMarkInexistent
endif

