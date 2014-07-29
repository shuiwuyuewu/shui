" Vim script
" Last Change: 2014-07-22
" Author: shuiwuyuewu
" Mail: shuiwuyuewu6@126.com
" History:
" 2014-07-20 : create the script
" 2014-07-21 : add the shui#Filter function
" 2014-07-22 : add the shui#Line function, correct shui#Filter function
" 2014-07-23 : add the shui#Unique function
" 2014-07-29 : modify the shui#Filter function, let default line count is 1
" 2014-07-29 : modify the script to correctly use in linux


" Run:
"     :runtime shui.vim
"     :Filter pattern ...


" Using for quick load
if !exists("s:did_load")
	command -nargs=+ Filter :call shui#Filter(<f-args>)
	command -nargs=+ Line :call shui#Line(<f-args>)
	command -nargs=0 Unique :call shui#Unique()
	let s:did_load = 1
	exe 'au FuncUndefined shui* source ' . expand('<sfile>')
	finish
endif

" Using for avoid loading file twice
if exists("g:loaded_shui")
	finish
endif
let g:loaded_shui = 1

" Function used for filter content, accordring to pattern
function shui#Filter(pattern, ...) 
	if a:0 > 1
		let l:header = shui#Line(a:2, 1) 
	else
		let l:header = shui#Line('*', 1) 
	endif
	let l:echo = '| echo l:header'
	if a:0 > 0
		let l:rows = a:1
	else
		let l:rows = 1
	endif
	if l:rows == 1
		let l:echo = ''
	endif
	redir => l:result
	silent exe 'g/'.a:pattern.'/z#.'.l:rows.l:echo
	redir END
	enew
	silent put = l:result
	silent exe 'normal gg2dd'
	let @/ = a:pattern
	silent exe 'normal n\<CR>'
endfunction

" Using char a:char to draw a line
function shui#Line(char, ...)
    silent exe 'normal 0'
	let l:line = repeat(a:char, &columns - &numberwidth - 1) 
	if a:0 > 0
		return l:line
	endif
	silent put = l:line
	silent exe "normal kdd"
endfunction

" Using for Unique the line
function shui#Unique()
	silent exe '%s/^\(.*\)\(\n\1\)\+$/\1/'
endfunction
