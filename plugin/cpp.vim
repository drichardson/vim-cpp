" noremap <Leader>s :SwitchSourceHeader()<CR>
command SwitchSourceHeader call cpp#switch#SourceHeader()

" Clang Formatting
command -range ClangFormat	<line1>,<line2> call cpp#clang#Format()
command -range ClangFormatAll	0,$ call cpp#clang#Format()

