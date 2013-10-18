if exists('g:swiki_loaded')
    finish
endif
let g:swiki_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 SWikiOpenTag call swiki#open_tag()




let &cpo = s:save_cpo
unlet s:save_cpo

