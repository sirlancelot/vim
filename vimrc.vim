" ===============================================
"    _  __(_)__ _  ________
"  _| |/ / //  ' \/ __/ __/
" (_)___/_//_/_/_/_/  \__/
"
" Maintainer: Matthew Pietz
" Version: v10
"
" ===============================================
set nocompatible encoding=utf8
" Initialize Path and Plugins {{{1
let mapleader = ","
let s:GUIRunning = has('gui_running')
let g:pathogen_disabled = []
filetype off                               " load these after pathogen
if !exists('g:loaded_pathogen') " {{{2
	" Cross-platform runtime paths
	set runtimepath=$HOME/.vim/personal,$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
	" source local, machine-specific settings
	runtime! vimrc.local.vim
	runtime pathogen.vim

	" Disable some plugins for console vim
	if !s:GUIRunning
		call extend(g:pathogen_disabled, ['supertab','indent-guides','solarized'])
	endif
	if v:version < 700
		call extend(g:pathogen_disabled, ['tabman','ctrlp'])
	endif

	call pathogen#runtime_append_all_bundles()
endif " }}}
filetype plugin indent on                  " ... here

function! SetIfDefault(Option, New) " {{{2
	let l:Current = eval('&'.a:Option)
	exe 'set '.a:Option.'&'
	exe 'set '.a:Option.'='.(l:Current == eval('&'.a:Option) ? a:New : l:Current)
endfunction " }}}

" }}} ===========================================
" Easily modify vimrc {{{1

nmap <leader>eg :e ~/.vim/gvimrc.vim<CR>
nmap <leader>ev :e ~/.vim/vimrc.vim<CR>
if has("autocmd")
	augroup VimrcHooks | au!
	augroup END
	" Reload `.vimrc` when saved
	" We only really care about $MYVIMRC when we need to reload it
	au VimrcHooks BufWritePost .vimrc,_vimrc,vimrc.vim,gvimrc.vim call sorc#ReloadRC()
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

" toggle show tabs and trailing whitespace
nmap <tab> :set list! list?<CR>
let &listchars="tab:".nr2char(9656).nr2char(183).",trail:".nr2char(8212)

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
	return substitute(line, '^\([-+]\+\)\(\s\+\)\(\d\+\) lines:', '\1 '.foldPercentage.'%\2(\3 lines)', 'g')
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
nnoremap <silent> <S-T> :call sorc#Preserve('%s/\s\+$//e')<CR>

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

if has('persistent_undo')
	" Set this to your Dropbox folder in `vimrc.local.cim`
	call SetIfDefault('undodir', '$HOME/.vimundo//')
	if !isdirectory(&undodir) | call mkdir(&undodir, "p") | endif
	set undofile
	set undolevels=1000
	set undoreload=10000
endif
set backup
set nowritebackup
set backupcopy=yes
call SetIfDefault('backupdir', '$HOME/.vimbackup')
call SetIfDefault('directory', '$HOME/.vimswap//')
if exists("*mkdir")
	" Create these directories if possible
	if !isdirectory(&backupdir) | call mkdir(&backupdir, "p") | endif
	if !isdirectory(&directory) | call mkdir(&directory, "p") | endif
endif

" Timestamp the backups
au VimrcHooks BufWritePre * let &backupext = '~' . localtime()
au VimrcHooks VimLeave * call sorc#DeleteOldBackups()

" }}} ===========================================
" Buffer Handling {{{1

" always switch to the current file directory
au VimrcHooks BufEnter * call <SID>ChangeWorkingDirectory()
function! s:ChangeWorkingDirectory() " {{{2
	if exists('b:git_dir')
		" Change to git root directory
		cd `=fnamemodify(b:git_dir,':h')`
	elseif expand('%:p') !~ '://'
		cd %:p:h
	endif
endfunction " }}}

" }}} ===========================================
" TabMan Plugin Settings {{{1
let g:tabman_number = 0

" }}} ===========================================
" Check for GUI {{{1
if s:GUIRunning | runtime! gvimrc.vim | endif
" }}} ===========================================
" vim:set syn=vim fdm=marker ts=8 sw=8 tw=0 noet:
