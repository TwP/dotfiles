"""
" vim settings organized by section, just like the docs
" :options for more information
"""

""" moving around, searching and patterns

set incsearch  " incremental searching
set ignorecase " searches are case insensitive...
set smartcase  " unless they contain a capital letter

""" displaying text

set scrolloff=3     " show at least 3 lines above/below cursor
set sidescrolloff=7 " and at least 7 columns next to cursor
set sidescroll=1    " and one to the left or right

set list      " show invisible characters
set listchars=tab:➤·,trail:·,nbsp:⋅,extends:»,precedes:«

set formatoptions-=o " dont continue comments when pushing o/O

set number         " show line numbers
"set relativenumber " and relatively so

""" syntax, highlighting, and spelling

set background=dark

syntax enable " turn on syntax highlighting, allow overrides

set hlsearch  " highlight matches

"set cursorline   " show screen line for cursor
"set cursorcolumn " show screen line for cursor
"set colorcolumn=+0,120 " show line at textwidth and 120 chars

""" multiple windows

set laststatus=2   " always show a status line

set winheight=10   " current window always has a nice size
set winminheight=3 " but the other windows aren't *too* small

set hidden " hide buffers when not displayed (vs. unloading them)

set splitbelow " open new splits to the bottom
set splitright " and to the right

""" messages and info

set showcmd  " show the current command as it's typed
set showmode " show current mode down the bottom

set ruler " show ruler in lower right

set visualbell t_vb= " visual bell, but disabled (no beeping!)

""" editing text

set nowrap    " don't wrap lines
set linebreak " wrap lines at convenient points

set textwidth=80 " a reasonable default, no?
set wrapmargin=80

set backspace=indent,eol,start " backspace through everything in insert mode

set nojoinspaces " disable two-space joins

""" tabs and indenting

set tabstop=2    " two-space tabs
set shiftwidth=2 " autoindent is two spaces
set expandtab    " use spaces, not tabs, by default
set autoindent

""" reading and writing files

set autoread " auto-reload any file modified outside vim

""" backups and swapfiles

set nobackup " don't create backup copies
set swapfile " but do use a swapfile

set dir=$TEMP " swapfile location

""" command line editing

set history=1000 " store lots of :cmdline history

""" folding settings

set foldmethod=indent " fold based on indent
set foldnestmax=3     " deepest fold is 3 levels
set nofoldenable      " dont fold by default

""" completion settings

set wildmenu              " enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest " make cmdline tab completion similar to bash

" what files to ignore when doing filename completion, etc.
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.class,.svn,*.gem,_site
" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
" Ignore bundler and sass cache
set wildignore+=**/vendor/gems,**/vendor/cache,**/node_modules,.bundle,.sass-cache
" Disable temp and backup files
set wildignore+=*.swp,*~,._*

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"tell the term it has 256 colors
set t_Co=256

colorscheme molokai

