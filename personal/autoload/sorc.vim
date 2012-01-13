" ===============================================
"   ___ ___     _  __(_)__ _  ________
"  (_-</ _ \  _| |/ / //  ' \/ __/ __/
" /___/\___/ (_)___/_//_/_/_/_/  \__/
"
" Maintainer: Matthew Pietz
" Version: v8
"
" ===============================================
function sorc#ReloadRC() " {{{1 Update unlinked VIMRC file on Windows
	if has('win32')
		let l:rcfile = readfile($HOME . '/.vim/vimrc.vim')
		call writefile(l:rcfile, $MYVIMRC)
	endif
	so $MYVIMRC
endfunction " }}}

function sorc#StripTrailingWhitespace() " {{{1
	let l:Pos = getpos(".")
	%s/$//e
	%s/\s\+$//e
	call setpos(".", l:Pos)
	nohl
endfunction " }}}

function sorc#DeleteOldBackups() " {{{1 Delete backups over 14 days old
	let l:Old = (60 * 60 * 24 * 14)
	let l:BackupFiles = split(glob(&backupdir."/*")."\n".glob(&backupdir."/.[^.]*"), "\n")
	let l:Now = localtime()

	for l:File in l:BackupFiles
		if (l:Now - getftime(l:File)) > l:Old
			call delete(l:File)
		endif
	endfor
endfunction " }}}

" vim:set syn=vim fdm=marker ts=8 sw=8 tw=0 noet:
