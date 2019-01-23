""" ctrlp
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 42

if executable('fd')
  let g:ctrlp_user_command = 'fd --color never --type f --full-path %s'
  let g:ctrlp_use_caching = 0
endif

" ctrlp-tjump
nnoremap <C-]> :CtrlPtjump<cr>
vnoremap <C-]> :CtrlPtjumpVisual<cr>

""" NERDTree
" auto-change CWD when changing tree root
let g:NERDTreeChDirMode=2
command! -n=? -complete=dir NT NERDTreeToggle <args>

let g:NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$', '^tags$']
let g:NERDTreeDirArrows=1

nnoremap <D-r> :NERDTreeToggle<CR>
nnoremap <D-R> :NERDTree<CR><C-w>p:NERDTreeFind<CR>

""" NERDCommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

""" Tabular
" sets ,a= to align = and => lines
map <leader>a= :Tabularize /=>\?<cr>

" sets ,a, to align on commas (useful for stacked method calls, etc)
map <leader>a, :Tabularize /,<cr>

" sets ,a: to align on colons :
map <leader>a: :Tabularize /:\zs<cr>

"mark syntax errors with :signs
let g:syntastic_enable_signs=1

" from aniero http://gist.github.com/179452
let g:fuzzy_ignore = "gems*;pkg/*"

""" copy-as-rtf/TOhtml
" tell TOhtml to disable line numbering when generating HTML
let g:html_number_lines=0
" and to use a reasonable font
let g:html_font="Andale Mono"

""" enable syntax highlighting in fenced markdown blocks
let g:markdown_fenced_languages = ['go', 'coffee', 'css', 'sass', 'ruby', 'erb=eruby', 'javascript', 'html', 'sh', 'xml', 'sql']

""" vim-json
" disable quote concealing
let g:vim_json_syntax_conceal = 0

""" ack.vim
" use the sliver searcher
let g:ackprg = 'ag --nogroup --nocolor --column --line-numbers'
nnoremap <C-s> :Ack "\b<C-R><C-W>\b"<CR>:cw<CR>
vnoremap <C-s> "hy:Ack "<C-r>=escape(@h,'./"*()[]?')<CR>"<CR>
map <leader>s :new<CR>:Ack<space>
vmap <leader>s "hy:new<CR>:Ack "<C-r>=escape(@h,'./"*()[]?')<CR>"<CR>
map <leader>ts :tabnew<CR>:Ack<space>
vmap <leader>ts "hy:tabnew<CR>:Ack "<C-r>=escape(@h,'./"*()[]?')<CR>"<CR>
map <leader>vs :vnew<CR>:Ack<space>
vmap <leader>vs "hy:vnew<CR>:Ack "<C-r>=escape(@h,'./"*()[]?')<CR>"<CR>

""" fatih/vim-go
" disable whitespace highlighting
au FileType go set nolist

au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gb <Plug>(go-build)
au FileType go nmap <leader>gt <Plug>(go-test)

au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

""" fugitive
" copy GitHub url to clipboard
nnoremap <silent> <Leader>cg :Gbrowse!<CR>
vnoremap <silent> <Leader>cg :'<,'>Gbrowse!<CR>

""" tagbar
map  <leader>tb :TagbarToggle<CR>
vmap <leader>tb :TagbarToggle<CR>

" tagbar markdown support from https://github.com/jszakmeister/markdown2ctags
let g:tagbar_type_markdown = {
  \ 'ctagstype': 'markdown',
  \ 'ctagsbin' : '/Users/tpease/.dotfiles/bin/markdown2ctags.py',
  \ 'ctagsargs' : '-f - --sort=yes',
  \ 'kinds' : [
    \ 's:sections',
    \ 'i:images'
  \ ],
  \ 'sro' : '|',
  \ 'kind2scope' : {
    \ 's' : 'section',
  \ },
  \ 'sort': 0,
\ }

" tagbar puppet support
let g:tagbar_type_puppet = {
  \ 'ctagstype': 'puppet',
  \ 'kinds': [
    \'c:class',
    \'s:site',
    \'n:node',
    \'d:definition'
  \]
\}

""" bgtags
" Allow vendor/internal-gems but not anything else in vendor.
" Generate ctags in parallel. Sorting doesn't matter, since this is
" shuffling the tags file anyway and I've set notagbsearch.
" Use ripper-tags for ruby.
let g:bgtags_user_commands = {
  \ 'directories': {
    \ '.git': [
      \ 'git ls-files -c -o --exclude-standard '':^*.rb'' '':^*.rake'' '':^*.go'' '':^*.git'' | ' .
        \ 'egrep -v ''^vendor/[^i][^n][^t]'' | ' .
        \ 'parallel -j200\% -N 500 --pipe ''ctags -L - -f -'' > tags',
      \ 'git ls-files -c -o --exclude-standard | ' .
        \ 'egrep -v ''^vendor/[^i][^n][^t]'' | ' .
        \ 'parallel -X -L200 ''ripper-tags -f - {}'' >> tags',
      \ 'git ls-files -c -o --exclude-standard ''*.go'' | ' .
        \ 'parallel -X -L200 ''gotags -f - {}'' >> tags'
      \ ],
    \ 'default': 'ctags -R'
    \ },
  \ 'filetypes': {
    \ 'ruby': 'ripper-tags -f -',
    \ 'default': 'ctags -f-'
    \}
\ }

map  <leader>bg :BgtagsUpdateTags<CR>
vmap <leader>bg :BgtagsUpdateTags<CR>
