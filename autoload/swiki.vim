let s:save_cpo = &cpo
set cpo&vim





let g:swiki_tag_begin = '[['
let g:swiki_tag_end = ']]'
let g:swiki_directory = '~/swiki'
let g:swiki_extention = '.txt'
" hoge日本語[[test]][[]]
function! swiki#open_tag()
    call s:open_tag()
endfunction

function! s:open_tag()
    let tagname = s:find_tag(getline('.'), col('.')-1)
    if tagname != ''
        let tagname = iconv(tagname, &encoding, 'UTF-8')
        if s:is_http(tagname)
            call system('open ' . tagname)
        else
            let tagfilename = s:make_filename(tagname)
            call s:dig_dir()
            echo s:make_path(tagname)
            execute 'e ' . s:make_path(tagname)
        endif
    endif
endfunction

function! s:find_tag(text, startpos)
    let rightpos = s:search_tag_end(a:text, a:startpos, g:swiki_tag_end) - 1
    let leftpos = s:search_tag_begin(a:text, rightpos, g:swiki_tag_begin) + strlen(g:swiki_tag_begin)
    if leftpos >= 0 && rightpos >= 0
        return a:text[leftpos : rightpos]
    endif
    return ''
endfunction

function! s:search_tag_begin(text, startpos, tagstr)
    let len = strlen(a:tagstr)-1
    let startpos = min([a:startpos+len, strlen(a:text)-1])
    let left = a:text[0 : startpos]
    let leftpos = match(left, '.*\zs' . a:tagstr)
    return leftpos
endfunction

function! s:search_tag_end(text, startpos, tagstr)
    let len = strlen(a:tagstr)-1
    let startpos = max([a:startpos-len, 0])
    let right = a:text[startpos : -1]
    let rightpos = match(right, a:tagstr)
    return rightpos >= 0 ? rightpos + startpos : rightpos
endfunction

function! s:encode_filename(filename)
    " todo 文字のエンコード
    let encname = iconv(a:filename, &encoding, 'UTF-8')
    return encname
endfunction

function! s:is_http(name)
    return match(a:name, '^https\?://') >= 0
endfunction

function! s:make_filename(name)
    return s:encode_filename(a:name) . g:swiki_extention
endfunction

function! s:make_path(name)
    return g:swiki_directory . '/' . s:make_filename(a:name)
endfunction

function! s:dig_dir()
    let dir = iconv(expand(g:swiki_directory), &encoding, 'UTF-8')
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo

