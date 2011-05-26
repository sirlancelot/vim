if exists("did_load_filetypes") | finish | endif

augroup filetypedetect
	au! BufRead,BufNewFile *.txt  setf text
augroup END
