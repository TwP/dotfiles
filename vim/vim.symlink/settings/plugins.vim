""" ctrlp-cmatcher
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 42

""" NERDTree

" auto-change CWD when changing tree root
let NERDTreeChDirMode=2
command! -n=? -complete=dir NT NERDTreeToggle <args>

let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$', '^tags$']
let NERDTreeDirArrows=1

nnoremap <D-r> :NERDTreeToggle<CR>
nnoremap <D-R> :NERDTree<CR><C-w>p:NERDTreeFind<CR>

let NERDSpaceDelims = 1

""" Tabular
" sets ,a= to align = and => lines
map <leader>a= :Tabularize /=>\?<cr>

" sets ,a, to align on commas (useful for stacked method calls, etc)
map <leader>a, :Tabularize /,<cr>

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
let g:markdown_fenced_languages = ['coffee', 'css', 'sass', 'ruby', 'erb=eruby', 'javascript', 'html', 'sh', 'xml', 'sql']

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

""" neitanod/vim-clevertab
" override ultisnips use of the <tab> key
let g:UltiSnipsExpandTrigger = '<F10>'
xnoremap <silent><tab> :call UltiSnips#SaveLastVisualSelection()<cr>gvs

" use the keyword first completion strategy
inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                      \<c-r>=CleverTab#Complete('ultisnips')<cr>
                      \<c-r>=CleverTab#Complete('tab')<cr>
                      \<c-r>=CleverTab#Complete('keyword')<cr>
                      \<c-r>=CleverTab#Complete('omni')<cr>
                      \<c-r>=CleverTab#Complete('stop')<cr>
inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>

""" fatih/vim-go
" disable whitespace highlighting
au FileType go set nolist

au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gb <Plug>(go-build)
au FileType go nmap <leader>gt <Plug>(go-test)

au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

""" tagbar
map  <leader>tb :TagbarToggle<CR>
vmap <leader>tb :TagbarToggle<CR>

let g:tagbar_type_markdown = {
  \ 'ctagstype' : 'markdown',
  \ 'kinds' : [
    \ 'h:Heading_L1',
    \ 'i:Heading_L2',
    \ 'k:Heading_L3',
    \ 'l:Heading_L4'
  \ ]
\ }
