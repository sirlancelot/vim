" ===============================================
"    _  __(_)__ _  ________
"  _| |/ / //  ' \/ __/ __/
" (_)___/_//_/_/_/_/  \__/
"
" Maintainer: Matthew Pietz
" Version: v7
"
" ===============================================
set nocompatible
let mapleader = ","
let s:GUIRunning = has('gui_running')
let g:pathogen_disabled = []
" Initialize Path and Plugins {{{1
filetype off                               " load these after pathogen
if !exists('g:loaded_pathogen') " {{{2
	" Cross-platform runtime paths
	set runtimepath=$HOME/.vim/personal,$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
	" source local, machine-specific settings
	runtime! vimrc.local.vim

	" Disable some plugins for console vim
	if !s:GUIRunning
		call extend(g:pathogen_disabled,['minibufexpl','supertab'])
	endif

	runtime pathogen.vim
	call pathogen#runtime_append_all_bundles()
	call pathogen#helptags()
endif " }}}
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
if !s:GUIRunning | colorscheme desert | endif
set background=dark
set cmdheight=2
set noequalalways
set nowrap
set showcmd
set showmatch
set splitbelow splitright
set viewoptions=folds,options,cursor,unix,slash

let &listchars="tab:".nr2char(10217)." ,trail:".nr2char(8212)

" Toggle code fold
nmap <space> za
nmap <s-space> zA

set foldtext=VimrcFoldText()
function! VimrcFoldText() " {{{2
	let line = foldtext()

	let foldSize = 1 + v:foldend - v:foldstart
	let lineCount = line("$")
	let foldPercentage = printf("%4.1f", (foldSize*1.0)/lineCount*100)

	" Show fold Percentage along with # of lines
	return substitute(line, '^\([-+]\+\)\(\s\+\)\(\d\+\) lines', '\1 '.foldPercentage.'%\2(\3 lines)', 'g')
endfunction " }}}

" }}} ===========================================
" Editing behavior {{{1
set backspace=indent,eol,start
set tabstop=8
set softtabstop=8
set shiftwidth=8
set shiftround
set smarttab

" Save a file even if I don't have write access (mac & linux only)
if s:GUIRunning && has('mac')
	cmap w!! w !security execute-with-privileges /usr/bin/tee % > /dev/null
else |  cmap w!! w !sudo tee % >/dev/null
endif

" Un/Indent blocks with tab
vnoremap <tab> >gv
vnoremap <s-tab> <gv

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

" Show help window vertically
cabbrev <expr> h getcmdline()=~'^h' ? 'vert h' : 'h'

" }}} ===========================================
" File Handling {{{1
set hidden       " switch between buffers without requiring save
set autoread     " load a file that was changed outside of vim

" Persistent undo, see vimrc.local.vim for `&undodir`
if has('undodir')
	if &undodir == '.' | set undodir=~/.vim/undo | endif
	if !isdirectory(&undodir) | call mkdir(&undodir, "p") | endif
	set undofile
	set undolevels=1000
	set undoreload=10000
endif
set backup
set nowritebackup
set backupcopy=yes
set backupdir=$HOME/.vimbackup
set directory=$HOME/.vimswap
if exists("*mkdir")
	" Create these directories if possible
	if !isdirectory(&backupdir) | call mkdir(&backupdir, "p") | endif
	if !isdirectory(&directory) | call mkdir(&directory, "p") | endif
endif

" Timestamp the backups
au VimrcHooks BufWritePre * let &backupext = '~' . localtime()
au VimrcHooks VimLeave * call <SID>DeleteOldBackups()
function! s:DeleteOldBackups() " {{{2 Delete backups over 14 days old
	let l:Old = (60 * 60 * 24 * 14)
	let l:BackupFiles = split(glob(&backupdir."/*")."\n".glob(&backupdir."/.[^.]*"), "\n")
	let l:Now = localtime()

	for l:File in l:BackupFiles
		if (l:Now - getftime(l:File)) > l:Old
			call delete(l:File)
		endif
	endfor
endfunction " }}}

" }}} ===========================================
" Buffer Handling {{{1

let g:miniBufExplSplitBelow = 0

" always switch to the current file directory
au VimrcHooks BufEnter * call <SID>ChangeWorkingDirectory()
function! s:ChangeWorkingDirectory() " {{{2
	if exists('b:git_dir')
		" Change to git root directory
		cd `=fnamemodify(b:git_dir,':h')`
	else
		cd %:p:h
	endif
endfunction " }}}

" }}} ===========================================
" FuzzyFinder Plugin Settings {{{1
map <leader>fb :FufBuffer<CR>
map <leader>ff :FufCoverageFile<CR>
nnoremap <silent> <C-]> :FufTagWithCursorWord!<CR>
vnoremap <silent> <C-]> :FufTagWithSelectedText!<CR>
" }}} ===========================================
" Check for GUI {{{1
if s:GUIRunning | runtime! gvimrc.vim | endif
" }}} ===========================================
" vim:set syn=vim fdm=marker ts=8 sw=8 tw=0 noet:
