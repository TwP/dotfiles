-- Core editor settings, ported from .vim/settings/basic.vim
-- Organized by section, like the original.

local opt = vim.opt

-- Disable neovim's built-in EditorConfig support. Projet .editorconfig files
-- will be ignored. Must be set before any file loads.
vim.g.editorconfig = false

-- moving around, searching and patterns
opt.incsearch = true   -- incremental searching
opt.ignorecase = true  -- searches are case insensitive...
opt.smartcase = true   -- unless they contain a capital letter

-- displaying text
opt.scrolloff = 3      -- show at least 3 lines above/below cursor
opt.sidescrolloff = 7  -- and at least 7 columns next to cursor
opt.sidescroll = 1     -- and one to the left or right

opt.list = true        -- show invisible characters
opt.listchars = { tab = "➤ ", trail = "•", nbsp = "–", extends = "»", precedes = "«" }

opt.formatoptions:remove("o") -- don't continue comments when pushing o/O

opt.number = true      -- show line numbers

-- syntax, highlighting, and spelling
opt.background = "dark"
opt.hlsearch = true    -- highlight matches
opt.termguicolors = true -- enable 24-bit color (modern terminals)

-- multiple windows
opt.laststatus = 2     -- always show a status line
opt.winheight = 10     -- current window always has a nice size
opt.winminheight = 3   -- but the other windows aren't *too* small
opt.hidden = true      -- hide buffers when not displayed
opt.splitbelow = true  -- open new splits to the bottom
opt.splitright = true  -- and to the right

-- messages and info
opt.showcmd = true     -- show the current command as it's typed
opt.showmode = true    -- show current mode down the bottom
opt.ruler = true       -- show ruler in lower right
opt.visualbell = true  -- visual bell instead of beeping
opt.errorbells = false

-- editing text
opt.wrap = false       -- don't wrap lines
opt.linebreak = true   -- wrap lines at convenient points (when wrap is on)
opt.textwidth = 80     -- a reasonable default
opt.wrapmargin = 80
opt.backspace = { "indent", "eol", "start" } -- backspace through everything
opt.joinspaces = false -- disable two-space joins

-- tabs and indenting
opt.tabstop = 2        -- two-space tabs
opt.shiftwidth = 2     -- autoindent is two spaces
opt.expandtab = true   -- use spaces, not tabs, by default
opt.autoindent = true

-- reading and writing files
opt.autoread = true    -- auto-reload any file modified outside vim

-- backups and swapfiles
opt.backup = false     -- don't create backup copies
opt.swapfile = true    -- but do use a swapfile

-- command line editing
opt.history = 1000     -- store lots of :cmdline history

-- folding settings
opt.foldmethod = "indent" -- fold based on indent
opt.foldnestmax = 3       -- deepest fold is 3 levels
opt.foldenable = false    -- don't fold by default

-- completion settings
opt.wildmenu = true
opt.wildmode = { "list:longest" } -- bash-like cmdline tab completion

-- files to ignore for filename completion
opt.wildignore:append({ "*.o", "*.out", "*.obj", ".git", "*.rbc", "*.class", ".svn", "*.gem", "_site" })
opt.wildignore:append({ "*.zip", "*.tar.gz", "*.tar.bz2", "*.rar", "*.tar.xz" })
opt.wildignore:append({ "**/vendor/gems", "**/vendor/cache", "**/node_modules", ".bundle", ".sass-cache" })
opt.wildignore:append({ "*.swp", "*~", "._*" })

-- mouse
opt.mouse = "a"

-- signcolumn: keep it always shown so diagnostics/git signs don't shift text
opt.signcolumn = "yes"

-- a shorter updatetime gives snappier diagnostics / CursorHold events
opt.updatetime = 250

-- give better completion-menu behaviour for nvim-cmp
opt.completeopt = { "menu", "menuone", "noselect" }
