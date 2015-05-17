
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

noremap <silent><Leader>o :call OpenTheThingUnderTheCursor()<CR>
function OpenTheThingUnderTheCursor()
  let view = winsaveview()
  let @0 = ''

  execute 'normal yib'
  if '' == @0
    execute 'normal yiW'
  endif

  call winrestview(view)
  exec '!open -g ' . @0
endfunction
