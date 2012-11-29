" ===============================================
"   ___ ___     _  __(_)__ _  ________
"  (_-</ _ \  _| |/ / //  ' \/ __/ __/
" /___/\___/ (_)___/_//_/_/_/_/  \__/
"
" Maintainer: Matthew Pietz
" Version: v10
"
" ===============================================
" Various commands that don't always need to be loaded by my .vimrc
" Update unlinked VIMRC file on Windows {{{1
function sorc#ReloadRC()
	if has('win32')
		let l:rcfile = readfile($HOME . '/.vim/vimrc.vim')
		call writefile(l:rcfile, $MYVIMRC)
	endif
	so $MYVIMRC
endfunction
" }}} ===========================================
" Save search history and cursor position {{{1
" http://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
function sorc#Preserve(command)
	let l:Search = @/
	let l:Pos = getpos('.')

	execute a:command

	let @/=l:Search
	call setpos('.', l:Pos)
	nohl
endfunction
" }}} ===========================================
" Delete backups over 14 days old {{{1
function sorc#DeleteOldBackups()
	let l:Old = (60 * 60 * 24 * 14)
	let l:BackupFiles = split(glob(&backupdir."/*")."\n".glob(&backupdir."/.[^.]*"), "\n")
	let l:Now = localtime()

	for l:File in l:BackupFiles
		if (l:Now - getftime(l:File)) > l:Old
			call delete(l:File)
		endif
	endfor
endfunction
" }}} ===========================================
" vim:set syn=vim fdm=marker ts=8 sw=8 tw=0 noet:
