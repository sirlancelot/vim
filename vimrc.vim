set nocompatible encoding=utf8
" ===============================================
"    _  __(_)__ _  ________
"  _| |/ / //  ' \/ __/ __/
" (_)___/_//_/_/_/_/  \__/
"
" Maintainer: Matthew Pietz
" Version: v10
"
" ===============================================
" Initialization {{{1
let s:GUIRunning = has('gui_running')
let mapleader = ","

" Cross-platform with a personal touch
set runtimepath=~/.vim/personal,~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" Vundle Essential {{{2
set runtimepath+=~/.vim/bundle/vundle
call vundle#rc()
set runtimepath-=~/.vim/bundle/vundle
Bundle 'gmarik/vundle'
" }}}

" source local, machine-specific settings
runtime! vimrc.local.vim

filetype off                       " Load filetypes after vundle
" Load Standard Vundles {{{2
Bundle 'csexton/jekyll.vim'
Bundle 'kchmck/vim-coffee-script'
Bundle 'mattn/zencoding-vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-surround'
if s:GUIRunning
	Bundle 'altercation/vim-colors-solarized'
	Bundle 'Shougo/neocomplcache'
endif
if v:version >= 700
	Bundle 'kien/ctrlp.vim'
endif
" }}}
filetype plugin indent on          " ... here

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
if (&t_Co > 16 || s:GUIRunning) | colorscheme mustang | endif
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

" Show fold Percentage along with # of lines
set foldtext=VimrcFoldText()
function! VimrcFoldText() " {{{2
	let line = foldtext()

	let foldSize = 1 + v:foldend - v:foldstart
	let lineCount = line("$")
	let foldPercentage = printf("%4.1f", (foldSize*1.0)/lineCount*100)

	return substitute(line, '^\([-+]\+\)\(\s\+\)\(\d\+\) lines:', '\1 '.foldPercentage.'%\2(\3 lines)', 'g')
endfunction " }}}

" }}} ===========================================
" Editing behavior {{{1
set backspace=indent,eol,start
set mousemodel=popup_setpos
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

" Edit in Window, Edit in Split, Edit in Vertical split, Edit in Tab
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>eu :vsp %%
map <leader>et :tabe %%

" }}} ===========================================
" Searching {{{1
set ignorecase
set smartcase
set hlsearch
set incsearch

" Turn off search highlighting
nnoremap <C-L> :nohlsearch<CR>
inoremap <C-L> <C-O>:nohlsearch<CR>

" Show help window vertically
cabbrev <expr> h getcmdline()=~'^h' ? 'vert h' : 'h'

" }}} ===========================================
" File Handling {{{1
set hidden       " switch between buffers without requiring save
set autoread     " load a file that was changed outside of vim

if has('persistent_undo')
	" Set this to your Dropbox folder in `vimrc.local.vim`
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
" NeoComplCache Plugin Settings {{{1
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_max_list = 15
let g:neocomplcache_force_overwrite_completefunc = 1

" SuperTab like snippets behavior.
inoremap <expr><TAB>   (pumvisible() ? "\<C-n>" : "\<TAB>")
inoremap <expr><S-TAB> (pumvisible() ? "\<C-p>" : "\<C-h>")

" }}} ===========================================
" Check for GUI {{{1
if s:GUIRunning | runtime! gvimrc.vim | endif
" }}} ===========================================
" vim:set syn=vim fdm=marker ts=8 sw=8 tw=0 noet:
