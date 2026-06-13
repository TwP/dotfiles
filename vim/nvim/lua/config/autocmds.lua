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

-- vim-go did `set nolist` for go files; preserve that
autocmd("FileType", {
  group = augroup("GoNoList", { clear = true }),
  pattern = "go",
  callback = function()
    vim.wo.list = false
  end,
})
