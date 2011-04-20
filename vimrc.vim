" vim:set syn=vim fdm=marker ts=8 sw=8 noet:
" ===============================================
"    _  __(_)__ _  ________
"  _| |/ / //  ' \/ __/ __/
" (_)___/_//_/_/_/_/  \__/
"
" Maintainer: Matthew Pietz
" Vim Version: 7.2
"
" ===============================================
set nocompatible
" Initialize Path and Plugins {{{1
if has('win32') || has('win64')
	" Cross-platform consistency
	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

let mapleader=","

filetype off                               " load these after pathogen
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on                  " ... here

" }}} ===========================================
" Easily modify vimrc {{{1
nmap <leader>eg :e ~/.vim/gvimrc.vim<CR>
nmap <leader>ev :e ~/.vim/vimrc.vim<CR>
if has("autocmd")
	augroup VimrcHooks
		au!
		" Reload `.vimrc` when saved
		au BufWritePost .vimrc,_vimrc,vimrc.vim,gvimrc.vim so $MYVIMRC
	augroup END
endif

" }}} ===========================================
" Look & feel {{{1
syntax on
colorscheme desert
set background=dark
set cmdheight=2
set noequalalways
set nowrap
set number
set showcmd
set showmatch
set splitbelow
set viewoptions=folds,options,cursor,unix,slash

set list
set listchars=tab:\⟩\ ,trail:—

" Toggle code fold
nmap <space> za

" }}} ===========================================
" Editing behavior {{{1
set tabstop=8
set softtabstop=8
set shiftwidth=8
set shiftround
set smarttab

" Save a file even if I don't have write access (linux only)
cmap w!! w !sudo tee % >/dev/null

" Shift+T Clears all trailing whitespace from the file
nnoremap <silent> <S-T> :call <SID>StripTrailingWhitespace()<CR>
function! s:StripTrailingWhitespace() " {{{2
	let l:Pos = getpos(".")
	%s/$//e
	%s/\s\+$//e
	call setpos(".", l:Pos)
	nohl
endfunction " }}}

" }}} ===========================================
" Searching {{{1
set ignorecase
set smartcase
set hlsearch
set incsearch

" Turn off search highlighting
nnoremap <C-L> :nohl<CR><C-L>
inoremap <C-L> <C-O>:nohl<CR>

" }}} ===========================================
" File Handling {{{1
set hidden       " switch between buffers without requiring save
set autoread     " load a file that was changed outside of vim
" always switch to the current file directory
au VimrcHooks BufEnter * cd %:p:h

set backup
set nowritebackup
set backupcopy=yes
set backupdir=$HOME/.vimbackup
set directory=$HOME/.vimswap,./

" Timestamp the backups
au VimrcHooks BufWritePre * let &backupext = '~' . localtime()
au VimrcHooks VimLeave * call <SID>DeleteOldBackups()
function! s:DeleteOldBackups() " {{{2
	" Delete backups over 14 days old
	let l:Old = (60 * 60 * 24 * 14)
	let l:BackupFiles = split(glob(&backupdir."/*", 1)."\n".glob(&backupdir."/.[^.]*",1), "\n")
	let l:Now = localtime()

	for l:File in l:BackupFiles
		if (l:Now - getftime(l:File)) > l:Old
			call delete(l:File)
		endif
	endfor
endfunction " }}}

" }}} ===========================================
" Check for GUI {{{1
if has('gui_running')
	runtime! gvimrc.vim
endif

" }}} ===========================================
