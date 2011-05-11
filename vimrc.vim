" ===============================================
"    _  __(_)__ _  ________
"  _| |/ / //  ' \/ __/ __/
" (_)___/_//_/_/_/_/  \__/
"
" Maintainer: Matthew Pietz
" Version: v2-dev
"
" ===============================================
set nocompatible
let mapleader=","
" Initialize Path and Plugins {{{1
let s:GUIRunning = has('gui_running')

filetype off                               " load these after pathogen
if !exists('g:loaded_pathogen') " {{{2
	if (has('win32') || has('win64'))
		" Make Windows more cross-platform friendly
		set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
	endif

	" Disable some plugins for console vim
	let g:pathogen_disabled = []
	if !s:GUIRunning
		call extend(g:pathogen_disabled,['minibufexpl','supertab'])
	endif

	runtime pathogen.vim
	let &rtp = expand("~/.vim/personal").",".&rtp
	call pathogen#runtime_append_all_bundles()
	call pathogen#helptags()
endif " }}}
filetype plugin indent on                  " ... here

" source local, machine-specific settings
runtime! vimrc.local.vim

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

" Toggle code fold
nmap <space> za
nmap <s-space> zA

set foldtext=VimrcFoldText()
function! VimrcFoldText() " {{{2
	" get first non-blank line
	let fs = v:foldstart
	while getline(fs) =~ '^\s*$'
		let fs = nextnonblank(fs + 1)
	endwhile
	if fs > v:foldend
		let line = getline(v:foldstart)
	else
		let line = getline(fs)
	endif
	let line = substitute(line, '/\*\|\*/\|{'.'{{\d\=', '', 'g')." "

	let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
	let foldSize = 1 + v:foldend - v:foldstart
	let foldSizeStr = " " . foldSize . " lines "
	let foldLevelStr = repeat("+--", v:foldlevel)
	let lineCount = line("$")
	let foldPercentage = "[" . printf("%4.1f", (foldSize*1.0)/lineCount*100) . "%] "
	let expansionString = repeat("-", w - strlen(foldSizeStr) - strlen(line) - strlen(foldLevelStr) - strlen(foldPercentage))
	return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction " }}}

" }}} ===========================================
" Editing behavior {{{1
set tabstop=8
set softtabstop=8
set shiftwidth=8
set shiftround
set smarttab

" Save a file even if I don't have write access (linux only)
cmap w!! w !sudo tee % >/dev/null

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

cabbrev <expr> h getcmdline()=~'^h' ? 'vert h' : 'h'

" }}} ===========================================
" File Handling {{{1
set hidden       " switch between buffers without requiring save
set autoread     " load a file that was changed outside of vim

set backup
set nowritebackup
set backupcopy=yes
set backupdir=$HOME/.vimbackup
set directory=$HOME/.vimswap,./
if exists("*mkdir")
	" Create these directories if possible
	if !isdirectory($HOME."/.vimbackup") | call mkdir($HOME . "/.vimbackup", "p") | endif
	if !isdirectory($HOME."/.vimswap")   | call mkdir($HOME . "/.vimswap", "p") | endif
endif

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
" Buffer Handling {{{1

let g:miniBufExplSplitBelow = 0

" always switch to the current file directory
au VimrcHooks BufEnter * call <SID>ChangeWorkingDirectory()
function! s:ChangeWorkingDirectory() " {{{2
	if exists('b:git_dir')
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
" vim:set syn=vim fdm=marker ts=8 sw=8 noet:
