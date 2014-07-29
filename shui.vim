" Vim script
" Last Change: 2014-07-22
" Author: shuiwuyuewu
" Mail: shuiwuyuewu6@126.com
" History:
" 2014-07-20 : create the script
" 2014-07-21 : add the Shui#Filter function
" 2014-07-22 : add the Shui#Line function, correct Shui#Filter function
" 2014-07-23 : add the Shui#Unique function
" 2014-07-29 : modify the Shui#Filter function, let default line count is 1


" Run:
"     :runtime shui.vim
"     :Filter pattern ...


" Using for quick load
if !exists("s:did_load")
	command -nargs=+ Filter :call Shui#Filter(<f-args>)
	command -nargs=+ Line :call Shui#Line(<f-args>)
	command -nargs=0 Unique :call Shui#Unique()
	let s:did_load = 1
	exe 'au FuncUndefined Shui* source ' . expand('<sfile>')
	finish
endif

" Using for avoid loading file twice
if exists("g:loaded_shui")
	finish
endif
let g:loaded_shui = 1

" Function used for filter content, accordring to pattern
function Shui#Filter(pattern, ...) 
	if a:0 > 1
		let l:header = Shui#Line(a:2, 1) 
	else
		let l:header = Shui#Line('*', 1) 
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
function Shui#Line(char, ...)
    silent exe 'normal 0'
	let l:line = repeat(a:char, &columns - &numberwidth - 1) 
	if a:0 > 0
		return l:line
	endif
	silent put = l:line
	silent exe "normal kdd"
endfunction

" Using for Unique the line
function Shui#Unique()
	silent exe '%s/^\(.*\)\(\n\1\)\+$/\1/'
endfunction
