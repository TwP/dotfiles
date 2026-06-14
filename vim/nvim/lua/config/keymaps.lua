-- Key mappings, ported from .vim/settings/editing.vim and misc.vim
-- (mapleader is set in init.lua before plugins load)

local map = vim.keymap.set

-- toggle relative line numbering
local function number_toggle()
  vim.wo.relativenumber = not vim.wo.relativenumber
end
map("n", "<Leader>n", number_toggle, { silent = true, desc = "Toggle relative numbers" })

-- move line-wise always, for markdown in particular
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")

-- map Q to something useful (reformat)
map({ "n", "v" }, "Q", "gq")

-- make Y consistent with C and D
map("n", "Y", "y$")

-- get the last pasted text (via evilchelu)
map("n", "gb", "'[V']")

-- strip leading tabs and trailing whitespace
vim.api.nvim_create_user_command("Tr", function()
  vim.cmd([[%s/\s\+$//ge]])
  vim.cmd([[%s/\t/  /ge]])
  vim.cmd("nohlsearch")
end, {})

-- replace the selected text
map("v", "<C-r>", [["hy:%s/\V<C-r>=escape(@h,'/')<CR>//gc<left><left><left>]])

-- search for the selected text in the current file
map("v", "<C-f>", [["hy:/\V<C-r>=escape(@h,'/')<CR>/<CR>]])

-- clearing search highlights (Cmd-l, GUI only)
map("n", "<D-l>", ":nohls<CR>", { silent = true })
map("i", "<D-l>", "<C-o>:nohls<CR>", { silent = true })

-- fullscreen toggle (Cmd-Esc, GUI only)
map("n", "<D-Esc>", ":set fullscreen!<CR>")
map("i", "<D-Esc>", "<C-O>:set fullscreen!<CR>")

-- easy command
map({ "n", "v" }, "<Space>", ":")

-- easy tabs
map({ "n", "v" }, "<leader>tn", ":tabnew<CR>")
map({ "n", "v" }, "<A-t>", ":tabnew<CR>")

-- new empty vertical split (to the right)
map({ "n", "v" }, "<C-w>N", ":vnew<CR>", { silent = true })

-- moving quickly between splits
map({ "n", "v" }, "<C-j>", "<C-w>j")
map({ "n", "v" }, "<C-k>", "<C-w>k")
map({ "n", "v" }, "<C-h>", "<C-w>h")
map({ "n", "v" }, "<C-l>", "<C-w>l")

-- fast zoom for a split
map({ "n", "v" }, "<C-_>", "<C-w>_")

-- fast tab switching (Cmd-j / Cmd-k, GUI only)
map({ "n", "v" }, "<D-j>", "gt")
map({ "n", "v" }, "<D-k>", "gT")

-- indent/outdent keeping selection (Cmd-] / Cmd-[, GUI only)
map("v", "<A-]>", ">gv")
map("v", "<A-[>", "<gv")
map("n", "<A-]>", ">>")
map("n", "<A-[>", "<<")
map("o", "<A-]>", ">>")
map("o", "<A-[>", "<<")
map("i", "<A-]>", "<Esc>>>i")
map("i", "<A-[>", "<Esc><<i")

-- Cmd-# to switch tabs (GUI only)
for i = 0, 9 do
  map({ "n", "v" }, "<D-" .. i .. ">", i .. "gt")
  map("i", "<D-" .. i .. ">", "<Esc>" .. i .. "gt")
end

-- tab movement (via ara howard), with wraparound
local function tab_move(dir) -- dir: -1 = left, 1 = right
  local nr = vim.fn.tabpagenr()
  local size = vim.fn.tabpagenr("$")
  if dir > 0 then
    vim.cmd(nr == size and "tabm 0" or "tabm +1")
  else
    vim.cmd(nr == 1 and "tabm" or "tabm -1")
  end
end
map({ "n", "v" }, "<Leader>m", "gT")
map({ "n", "v" }, "<Leader>.", "gt")
map({ "n", "v" }, "<C-Left>", function() tab_move(-1) end)
map({ "n", "v" }, "<C-Right>", function() tab_move(1) end)

-- Fake '|' as text object (via coderwall.com/p/zfqmiw)
for _, action in ipairs({ "d", "c", "y", "v" }) do
  map("n", action .. "i|", "T|" .. action .. ",")
  map("n", action .. "a|", "F|" .. action .. ",")
  map("n", action .. "i/", "T/" .. action .. ",")
  map("n", action .. "a/", "F/" .. action .. ",")
end

-- misc.vim: HighlightLongLines command
vim.api.nvim_create_user_command("HighlightLongLines", function(o)
  local width = tonumber(o.args) or 79
  if width > 0 then
    vim.cmd("match Todo /\\%>" .. width .. "v/")
  else
    vim.notify("Usage: HighlightLongLines [natural number]", vim.log.levels.WARN)
  end
end, { nargs = "?" })

-- misc.vim: open the thing under the cursor with `open`
local function open_thing_under_cursor()
  local view = vim.fn.winsaveview()
  vim.fn.setreg("0", "")
  vim.cmd("normal yib")
  if vim.fn.getreg("0") == "" then
    vim.cmd("normal yiW")
  end
  vim.fn.winrestview(view)
  vim.fn.system("open -g " .. vim.fn.shellescape(vim.fn.getreg("0")))
end
map("n", "<Leader>o", open_thing_under_cursor, { silent = true, desc = "Open thing under cursor" })

-- misc.vim: Ruby hashrocket -> new hash syntax
map("n", "<leader>hs", [[:s/\(\s\+\|[{(,]\)\zs:\(\h\w*[!=?]\?\)\s\+=>\s\+/\2: /g<cr>]])

-- misc.vim: redraw the window
map("n", "<leader>r", ":redraw!<cr>")
