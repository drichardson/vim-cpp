" Format a range. I've found this only works properly if the beginning of the
" range has the function you want to format. You can't just arbitrarily format
" a sub-section of a function, in my tests.
function cpp#clang#Format() range
	echom "Calling clangFormat"
	if !executable('clang-format')
		call cpp#common#Warn('Cannot find clang-format')
		return
	endif
	let l:lines=(a:firstline+1).':'.(a:lastline+1)
	echom "Formatting lines (1-based) ".l:lines
	py3file ~/.vim/clang-format.py
endfunction

" Format a file on save. Use in an autocmd like this:
" autocmd BufWritePre *.h,*.cc,*.cpp,*.c call cpp#clang#FormatOnSave()
function cpp#clang#FormatOnSave()
	if !executable('clang-format')
		call cpp#common#Warn('Cannot find clang-format')
		return
	endif
	" Only do this if a .clang-format or _clang
	let path=expand('%:p') . ';'
	let file=findfile(".clang-format", path)
	if empty(file)
		let file=findfile("_clang-format", path)
	endif
	if empty(file)
		echom "Did not find clang format file"
		return
	endif

	if filewritable(expand('%'))
		" File exists, only format differences.
		echom "Existing file, only formatting differences."
		let l:formatdiff = 1
	else
		" File does not exist, format everything.
		echom "New file, formatting all"
		let l:lines='all'
	endif


	py3file ~/.vim/clang-format.py

endfunction

