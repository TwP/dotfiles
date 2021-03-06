
" Close all open buffers on entering a window if the only buffer that's left is
" the NERDTree buffer
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" jump to last cursor position when opening a file
" dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

" Do not create backups when editing crontab files
autocmd filetype crontab setlocal nobackup nowritebackup

" Enable spell checking for markdown files and for git commit buffers
autocmd BufEnter,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell
