" noremap <Leader>s :SwitchSourceHeader()<CR>
command SwitchSourceHeader call cpp#switch#SourceHeader()

" Clang Formatting
command -range ClangFormat	<line1>,<line2> call cpp#clang#FormatRange()
command ClangFormatAll		call cpp#clang#FormatAll()

