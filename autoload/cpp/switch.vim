function cpp#switch#SourceHeader()
	let headerExtensions = ['h', 'hxx', 'hpp']
	let sourceExtensions = ['c', 'cpp', 'cxx', 'cc']

	let fileExtension = expand('%:e')

	if index(headerExtensions, fileExtension) != -1
		let pattern = expand('%:t:r').'.c*'
	elseif index(sourceExtensions, fileExtension) != -1
		let pattern = expand('%:t:r').'.h*'
	else
		call cpp#common#Warn("Extension " . 
					\ fileExtension . 
					\ " is not known to be a header or source file.")
		return
	endif

	" echom 'Using pattern: '.pattern
	let stop_dirs=['.svn', '.git', '.hg']
	let maxlevels=3
	let results=s:SearchUpward(expand('%'), pattern, stop_dirs, maxlevels)
	if empty(results)
		call cpp#common#Warn('No corresponding file found.')
		return
	endif

	if len(results) > 1
		echom 'Found '.len(results).' candidates. Using first one.'
	endif

	execute 'edit' results[0]
endfunction

" Starting from the directory that contains <start_path>, search for files
" matching <pattern> until files are found, a directory matching an item in
" <stop_dirs> is reached, or <maxlevels> directory levels have been searched.
function s:SearchUpward(start_path, pattern, stop_dirs, maxlevels)
	let dir=fnamemodify(a:start_path, ':p:h')
	let lastdir=''
	let levels=0

	while dir != lastdir
		"echom 'globbing '.dir.'/'.a:pattern
		let results=glob(dir.'/**/'.a:pattern, v:true, v:true)
		if !empty(results)
			return results
		endif

		let dirname=fnamemodify(dir, ':t')
		if index(a:stop_dirs, dirname) != -1
			echom 'A stop directory was reached. '.dirname
			return []
		endif

		let lastdir=dir
		let dir=fnamemodify(dir, ':h')
		let levels=levels+1

		if levels > a:maxlevels
			echom 'Max upsearch search level ('.a:maxlevels.') reached.'
			return []
		endif
	endwhile

	return []
endfunction
