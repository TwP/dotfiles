-- Neovim configuration
-- Ported from a Vundle-based vim setup, with VSCode-like LSP features added.
--
-- Layout:
--   lua/config/options.lua   core editor settings (from .vim/settings/basic.vim)
--   lua/config/keymaps.lua   key mappings (from .vim/settings/editing.vim, misc.vim)
--   lua/config/autocmds.lua  autocommands (from .vim/settings/autocommands.vim)
--   lua/config/lazy.lua      plugin manager bootstrap
--   lua/plugins/*.lua        plugin specs (lsp, completion, treesitter, etc.)

-- mapleader must be set before lazy.nvim and any plugins load.
vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false

-- vim.o.guifont = "FiraCode Nerd Font:h14:#e-subpixelantialias:#f-liga=0:#f-calt=0"
-- vim.o.guifont = "FiraCode Nerd Font:h14:#f-calt=0:#f-liga=0"

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
