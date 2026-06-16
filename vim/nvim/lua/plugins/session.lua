-- auto-session: save the window/tab/buffer layout on exit and restore it the
-- next time nvim is launched (with no file args) in the same directory.
--
-- Sessions are stored under stdpath("data")/sessions/ by default
-- (~/.local/share/nvim/sessions/), one file per working directory.

return {
  "rmagatti/auto-session",
  lazy = false,
  init = function()
    -- What gets captured in the session. "tabpages"/"winsize"/"winpos"
    -- preserve the tab and window layout; "localoptions" keeps per-buffer
    -- options (e.g. the markdown textwidth tweak) on restore.
    vim.o.sessionoptions =
      "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
  opts = {
    -- Close the nvim-tree sidebar before saving so the session doesn't
    -- restore a stale/empty tree window.
    pre_save_cmds = { "NvimTreeClose" },
    -- A restored session always runs during VimEnter, which short-circuits the
    -- nvim-tree auto-open in editor.lua. Reopen the sidebar here (without
    -- stealing focus) so it still appears after a session is restored.
    post_restore_cmds = {
      function()
        require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
      end,
    },
  },
}
