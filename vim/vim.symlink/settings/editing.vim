" basic editing
let mapleader = ','
let maplocalleader = ','

" enable plugin filetypes and indentation
filetype plugin indent on

" toggle relative line numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

nnoremap <Leader>n :silent call NumberToggle()<cr>

" move line-wise always, for markdown in particular
map j gj
map k gk

" map Q to something useful
noremap Q gq

" make Y consistent with C and D
nnoremap Y y$

" get the last pasted text (via evilchelu)
nnoremap gb '[V']

" strip leading tabs and trailing whitespace
command! Tr %s/\s\+$//ge | %s/\t/  /ge | nohlsearch

" replace the selected text
vnoremap <C-r> "hy:%s/\V<C-r>=escape(@h,'/')<CR>//gc<left><left><left>

" search for the selected text in the current file
" this is useful for more complex strings than #/* can search
vnoremap <C-f> "hy:/\V<C-r>=escape(@h,'/')<CR>/<CR>

" cmd-8 for clearing search highlights
nnoremap <D-l> :nohls<CR>
inoremap <D-l> <C-o>:nohls<CR>

" map fullscreen toggle to be cmd-esc
nnoremap <D-Esc> :set fullscreen!<CR>
inoremap <D-Esc> <C-O>:set fullscreen!<CR>

" easy command
map <Space> :

" easy tabs
map <leader>tn :tabnew<CR>

""" moving quickly between splits

map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" fast zoom for a split
map <C-_> <C-w>_

""" indent and tab switching

" fast tab switching
map <D-j> gt
map <D-k> gT

" Map command-[ and command-] to indenting or outdenting
" while keeping the original selection in visual mode
vmap <D-]> >gv
vmap <D-[> <gv

nmap <D-]> >>
nmap <D-[> <<

omap <D-]> >>
omap <D-[> <<

imap <D-]> <Esc>>>i
imap <D-[> <Esc><<i

" Map Command-# to switch tabs
map  <D-0> 0gt
imap <D-0> <Esc>0gt
map  <D-1> 1gt
imap <D-1> <Esc>1gt
map  <D-2> 2gt
imap <D-2> <Esc>2gt
map  <D-3> 3gt
imap <D-3> <Esc>3gt
map  <D-4> 4gt
imap <D-4> <Esc>4gt
map  <D-5> 5gt
imap <D-5> <Esc>5gt
map  <D-6> 6gt
imap <D-6> <Esc>6gt
map  <D-7> 7gt
imap <D-7> <Esc>7gt
map  <D-8> 8gt
imap <D-8> <Esc>8gt
map  <D-9> 9gt
imap <D-9> <Esc>9gt

""" tab movement setup, via ara howard

function! TabMove(n)
    let nr = tabpagenr()
    let size = tabpagenr('$')
    " do we want to go left?
    if (a:n != 0)
        let nr = nr - 2
    endif
    " crossed left border?
    if (nr < 0)
        let nr = size-1
        " crossed right border?
    elseif (nr == size)
        let nr = 0
    endif
    " fire move command
    exec 'tabm'.nr
endfunction

map <Leader>m gT
map <Leader>. gt
map <C-Left> :call TabMove(1)<CR>
map <C-Right> :call TabMove(0)<CR>

""" from http://coderwall.com/p/zfqmiw

" Fake '|' as text object
nnoremap di\| T\|d,
nnoremap da\| F\|d,
nnoremap ci\| T\|c,
nnoremap ca\| F\|c,
nnoremap yi\| T\|y,
nnoremap ya\| F\|y,
nnoremap vi\| T\|v,
nnoremap va\| F\|v,

" Fake '/' as text object
nnoremap di/ T/d,
nnoremap da/ F/d,
nnoremap ci/ T/c,
nnoremap ca/ F/c,
nnoremap yi/ T/y,
nnoremap ya/ F/y,
nnoremap vi/ T/v,
nnoremap va/ F/v,
