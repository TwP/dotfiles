
"map to bufexplorer
nnoremap <C-B> :BufExplorer<cr>

"mark syntax errors with :signs
let g:syntastic_enable_signs=1

" from aniero http://gist.github.com/179452
noremap <D-r> :NERDTreeToggle<CR>
noremap <D-R> :NERDTreeFind<CR>

let g:fuzzy_ignore = "gems*;pkg/*"
let g:NERDSpaceDelims = 1

let NERDTreeChDirMode=2 " auto-change CWD when changing tree root

command! Nt  :NERDTreeToggle
command! Ntm :NERDTreeMirror

" ----- syntax copying for presentations -----

" tell TOhtml to disable line numbering when generating HTML
let g:html_number_lines=0
" and to use a reasonable font
let g:html_font="Andale Mono"

""" Disable folding in markdown files
let g:vim_markdown_folding_disabled=1
