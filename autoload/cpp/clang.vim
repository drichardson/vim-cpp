" Run at top level since it needs to be done when executing a :source command.
let s:packagedir = expand('<sfile>:p:h:h:h')

" Format a range. I've found this only works properly if the beginning of the
" range has the function you want to format. You can't just arbitrarily format
" a sub-section of a function, in my tests.
function cpp#clang#FormatRange() range
	if !executable('clang-format')
		call cpp#common#Warn('Cannot find clang-format')
		return
	endif
	let l:lines=(a:firstline).':'.(a:lastline)

	" Do NOT move this code block into a function. It needs to be executed
	" in the same Vim context that l:lines is defined.
	let script = s:packagedir . '/clang-format.py'
	if has('python3')
		execute 'py3file' script
	elseif has('python')
		execute 'pyfile' script
	endif
endfunction

" Format a range. I've found this only works properly if the beginning of the
" range has the function you want to format. You can't just arbitrarily format
" a sub-section of a function, in my tests.
function cpp#clang#FormatAll()
	if !executable('clang-format')
		call cpp#common#Warn('Cannot find clang-format')
		return
	endif
	let l:lines='all'

	" Do NOT move this code block into a function. It needs to be executed
	" in the same Vim context that l:lines is defined.
	let script = s:packagedir . '/clang-format.py'
	if has('python3')
		execute 'py3file' script
	elseif has('python')
		execute 'pyfile' script
	endif
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
		" Did not find .clang-format
		return
	endif

	if filewritable(expand('%'))
		" File exists, only format differences.
		let l:formatdiff = 1
	else
		" File does not exist, format everything.
		let l:lines='all'
	endif

	" Do NOT move this code block into a function. It needs to be executed
	" in the same Vim context that l:lines is defined.
	let script = s:packagedir . '/clang-format.py'
	if has('python3')
		execute 'py3file' script
	elseif has('python')
		execute 'pyfile' script
	endif
endfunction


