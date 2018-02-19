
" define :HighlightLongLines command to highlight the offending parts of
" lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
  let targetWidth = a:width != '' ? a:width : 79
  if targetWidth > 0
    exec 'match Todo /\%>' . (targetWidth) . 'v/'
  else
    echomsg "Usage: HighlightLongLines [natural number]"
  endif
endfunction

""" open the text under the cursor
" if the text is a URL, then it will be opened in the default browser
noremap <silent><Leader>o :call OpenTheThingUnderTheCursor()<CR>
function OpenTheThingUnderTheCursor()
  " save cursor state and clear register 0
  let view = winsaveview()
  let @0 = ''

  " yank the inner block of text between parens
  execute 'normal yib'
  if '' == @0
    " if that returned nothing than yank between whitespace
    execute 'normal yiW'
  endif

  " restore the cursor state
  call winrestview(view)

  " and now pass our text along to the `open` command
  exec '!open -g ' . @0
endfunction

""" Ruby - change hacshrockets to new hash syntax
map <leader>hs :s/\(\s\+\\|[{(,]\)\zs:\(\h\w*[!=?]\?\)\s\+=>\s\+/\2: /g<cr>

""" Redraw the vim window
map <leader>r :redraw!<cr>
