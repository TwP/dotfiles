-- Editor plugins: direct counterparts to your existing Vundle plugins.

return {
  -- nerdtree -> nvim-tree (file explorer)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Load eagerly (lazy=false) so the tree can open at startup. The keys
    -- below are still registered as normal mappings once it loads.
    lazy = false,
    keys = {
      { "<leader>nt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "<leader>nf", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal file in tree" },
    },
    opts = {
      sync_root_with_cwd = true,
      view = { width = 35 },
      renderer = { group_empty = true },
      filters = { custom = { "^\\.git$", "\\.pyc$", "\\.rbc$", "\\~$" } },
      -- mirror the tree across tabs: open it on a new tabpage (and close with it)
      tab = { sync = { open = true, close = true } },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      -- Open the tree automatically on startup, without stealing focus from
      -- the file you opened (or the empty buffer when running bare `nvim`).
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeOpenOnStart", { clear = true }),
        callback = function(data)
          -- A session restore (auto-session) may have wiped the original
          -- startup buffer by the time this runs, leaving data.buf invalid.
          if not vim.api.nvim_buf_is_valid(data.buf) then
            return
          end

          -- Don't pop the tree when nvim was launched to edit a git message
          -- (commit, rebase todo, merge, tag, etc.) -- it's just noise there.
          local git_filetypes = { gitcommit = true, gitrebase = true }
          if git_filetypes[vim.bo[data.buf].filetype] then
            return
          end

          -- `gh` (and similar tools) open a markdown tempfile to write a PR/
          -- issue body. Skip the tree for markdown only when it lives in a temp
          -- dir, so editing your own .md files still pops the tree.
          if vim.bo[data.buf].filetype == "markdown" then
            local tmp = vim.fn.resolve((vim.uv or vim.loop).os_tmpdir() or "/tmp")
            local file = vim.fn.resolve(vim.fn.fnamemodify(data.file, ":p"))
            if file:sub(1, #tmp) == tmp then
              return
            end
          end

          local real_file = vim.fn.filereadable(data.file) == 1
          local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
          if not real_file and not no_name then
            return -- e.g. `nvim some-dir` or a startup screen; leave it alone
          end
          require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
        end,
      })

      -- When the last real window in a tab is closed and only nvim-tree (plus
      -- any floating windows) would remain, close the tree too. This collapses
      -- the now-empty tab -- and if it was the last tab, exits Neovim -- instead
      -- of leaving a tab (or the whole editor) showing just the sidebar.
      vim.api.nvim_create_autocmd("QuitPre", {
        group = vim.api.nvim_create_augroup("NvimTreeQuitOnLast", { clear = true }),
        callback = function()
          local tree_wins = {}
          local floating_wins = {}
          local wins = vim.api.nvim_tabpage_list_wins(0)
          for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
              table.insert(tree_wins, w)
            end
            if vim.api.nvim_win_get_config(w).relative ~= "" then
              table.insert(floating_wins, w)
            end
          end
          -- If the window being quit is the last non-tree, non-floating window
          -- in this tab, close the tree window(s) so the tab collapses (or
          -- Neovim exits when it's the only tab left).
          if 1 == #wins - #floating_wins - #tree_wins then
            for _, w in ipairs(tree_wins) do
              vim.api.nvim_win_close(w, true)
            end
          end
        end,
      })
    end,
  },

  -- tpope/vim-fugitive (+ rhubarb) -> still the best; use as-is.
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    cmd = { "Git", "G", "GBrowse" },
    keys = {
      { "<leader>cg", "<cmd>GBrowse!<cr>", desc = "Copy GitHub URL" },
      { "<leader>cg", ":'<,'>GBrowse!<cr>", mode = "v", desc = "Copy GitHub URL (range)" },
    },
  },

  -- gitsigns: signs in the gutter + inline blame (was partly done via fugitive)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- tpope/vim-surround -> nvim-surround (lua port, same idea)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- tpope/vim-unimpaired -> still maintained, use as-is
  { "tpope/vim-unimpaired", event = "VeryLazy" },

  -- scrooloose/nerdcommenter -> Comment.nvim
  -- gcc to toggle a line, gc in visual mode. (NERDSpaceDelims-style padding.)
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- godlygeek/tabular -> still works in nvim, keep your <leader>a mappings
  {
    "godlygeek/tabular",
    cmd = "Tabularize",
    keys = {
      { "<leader>a=", ":Tabularize /=><bar>=<cr>", mode = { "n", "v" }, desc = "Align =/=>"},
      { "<leader>a,", ":Tabularize /,<cr>", mode = { "n", "v" }, desc = "Align commas" },
      { "<leader>a:", ":Tabularize /:\\zs<cr>", mode = { "n", "v" }, desc = "Align colons" },
    },
  },

  -- majutsushi/tagbar -> still maintained; LSP document symbols (Telescope)
  -- are the modern alternative, but keep tagbar for the <leader>tb habit.
  {
    "preservim/tagbar",
    cmd = "TagbarToggle",
    keys = {
      { "<leader>tb", "<cmd>TagbarToggle<cr>", mode = { "n", "v" }, desc = "Toggle tagbar" },
    },
  },

  -- fatih/vim-go -> keep it for the :GoRun/:GoBuild/:GoTest workflow only.
  -- The native LSP client (lsp.lua) owns gopls for definitions/completion/
  -- diagnostics; vim-go's own gopls is disabled so we don't run two instances.
  {
    "fatih/vim-go",
    ft = "go",
    build = ":GoUpdateBinaries",
    init = function()
      -- let the native LSP client own gopls; don't let vim-go start a second
      -- gopls instance (avoids duplicate diagnostics/gutter signs).
      vim.g.go_gopls_enabled = 0
      vim.g.go_code_completion_enabled = 0
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_doc_keywordprg_enabled = 0
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          local o = { buffer = true }
          vim.keymap.set("n", "<leader>gr", "<Plug>(go-run)", o)
          vim.keymap.set("n", "<leader>gb", "<Plug>(go-build)", o)
          vim.keymap.set("n", "<leader>gt", "<Plug>(go-test)", o)
        end,
      })
    end,
  },

  -- vim-json: vim-markdown's json bits are covered by treesitter; keep conceal off
  -- (matches g:vim_json_syntax_conceal = 0)
  { "elzr/vim-json", ft = "json", init = function() vim.g.vim_json_syntax_conceal = 0 end },
}
