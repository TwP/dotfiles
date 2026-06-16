-- Autocommands, ported from .vim/settings/autocommands.vim

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- jump to last cursor position when opening a file,
-- but not when writing a commit log entry
autocmd("BufReadPost", {
  group = augroup("LastCursorPosition", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].filetype:match("commit") then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      vim.cmd("normal! zz")
    end
  end,
})

-- do not create backups when editing crontab files
autocmd("FileType", {
  group = augroup("CrontabNoBackup", { clear = true }),
  pattern = "crontab",
  callback = function()
    vim.bo.backup = false
    vim.bo.writebackup = false
  end,
})

-- enable spell checking for markdown and git commit buffers
autocmd({ "BufEnter", "BufNewFile" }, {
  group = augroup("MarkdownSpell", { clear = true }),
  pattern = "*.md",
  callback = function()
    vim.wo.spell = true
  end,
})
autocmd("FileType", {
  group = augroup("GitCommitSpell", { clear = true }),
  pattern = "gitcommit",
  callback = function()
    vim.wo.spell = true
  end,
})

-- disable automatic line wrapping for markdown files
autocmd("FileType", {
  group = augroup("MarkdownNoWrap", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.bo.textwidth = 0
    vim.bo.wrapmargin = 0
  end,
})

-- In help buffers, restore the built-in <C-]> (jump to help tag under cursor).
-- A global <C-]> mapping (Telescope tag jump, see plugins/telescope.lua) would
-- otherwise shadow it; a buffer-local mapping takes precedence here.
autocmd("FileType", {
  group = augroup("HelpTagJump", { clear = true }),
  pattern = "help",
  callback = function(args)
    vim.keymap.set("n", "<C-]>", "<C-]>", {
      buffer = args.buf,
      remap = false,
      desc = "Jump to help tag under cursor",
    })
  end,
})

-- Go indents with hard tabs: show the usual invisible characters
-- (from options.lua) but render tabs as blank instead of marking them.
autocmd("FileType", {
  group = augroup("GoListNoTab", { clear = true }),
  pattern = "go",
  callback = function()
    local listchars = vim.opt_global.listchars:get()
    listchars.tab = "  "
    vim.opt_local.listchars = listchars
  end,
})
