" ===============================================
"    ___ __  __(_)__ _  ________
"  _/ _ `/ |/ / //  ' \/ __/ __/
" (_)_, /|___/_//_/_/_/_/  \__/
"  /___/
"
" Maintainer: Matthew Pietz
" Version: v6
"
" ===============================================
" Configuration for Gui Vim
set guioptions-=T       " Hide the toolbar, it's lame

set guitablabel=%t      " Show just the filename in the tab
set guitabtooltip=%F    " Show the full path on rollover
set switchbuf=usetab

" Increase visuals {{{1
set number
set laststatus=2
set statusline=%<%f\ %h%m%r%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

colorscheme molokai     " Soft colors for gui vim

" }}} ===========================================
" Platform specific stuff {{{1
if has('gui_win32') " Windows {{{2
	set guifont=Consolas
" }}} ===========================================
elseif has('gui_macvim') " MacVim {{{2
	set macmeta                    " Allow alt key to be mapped
	set guifont=Inconsolata:h13
	set showtabline=2              " Always show the tab bar

	set transparency=4
" }}} ===========================================
elseif has('gui_gtk') " Gnome {{{2
	set guifont=DejaVu\ Sans\ Mono\ 9
	set showtabline=2             " Always show the tab bar

	" Different fixes for disappearing mouse problem
	set nomousehide
	au VimrcHooks GUIEnter * set ttymouse=xterm
" }}} ===========================================
end
" }}} ===========================================
" Add Common User Interface keyboard shortcuts {{{1
" Most of this was taken from $VIMRUNTIME/mswin.vim
if has('gui_win32') || has('gui_gtk2')
	if !has('unix')
		set guioptions-=a
	endif

	" Delete selections with backspace
	vnoremap <BS> d

	" Cut, Copy, & Paste
	vnoremap <C-X> "+x
	vnoremap <S-Del> "+x
	vnoremap <C-C> "+y
	vnoremap <C-Insert> "+y
	map <S-Insert> "+gP
	cmap <S-Insert> <C-R>+
	exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
	exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
	imap <S-Insert> <C-V>
	vmap <S-Insert> <C-V>

	" Save...
	noremap <C-S> :update<CR>
	vnoremap <C-S> <C-C>:update<CR>
	inoremap <C-S> <C-O>:update<CR>

	" Undo & Repeat...
	noremap <C-Z> u
	inoremap <C-Z> <C-O>u
	noremap <C-Y> <C-R>
	inoremap <C-Y> <C-O><C-R>

	" Select All...
	noremap <C-A> gggH<C-O>G
	inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
	cnoremap <C-A> <C-C>gggH<C-O>G
	onoremap <C-A> <C-C>gggH<C-O>G
	snoremap <C-A> <C-C>gggH<C-O>G
	xnoremap <C-A> <C-C>ggVG
endif
" }}} ===========================================
" vim:set syn=vim fdm=marker ts=8 sw=8 noet:
