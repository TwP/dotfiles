-- Telescope: fuzzy finder. Modern replacement for ctrlp + ack.vim.
-- Files, live grep, buffers, and LSP-powered symbol/definition pickers.

return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- native fzf sorter for speed (built with make)
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  keys = {
    -- File navigation (ctrlp replacement). <C-p> is the classic muscle memory.
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },

    -- Search in project (ack.vim replacement). Uses ripgrep.
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    {
      "<C-s>",
      function()
        require("telescope.builtin").grep_string({ word_match = "-w" })
      end,
      desc = "Grep word under cursor",
    },
    {
      "<C-s>",
      '"hy:Telescope grep_string default_text=<C-r>h<cr>',
      mode = "v",
      desc = "Grep selection",
    },

    -- LSP-powered pickers: nicer than the default quickfix lists.
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References (Telescope)" },
    { "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
    { "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },

    -- Tag jump (your old <C-]> via ctrlp-tjump). Falls back to tags file.
    { "<C-]>", "<cmd>Telescope tags default_text=<cword><cr>", desc = "Jump to tag" },
  },
  config = function()
    local telescope = require("telescope")

    -- nvim-treesitter's `main` branch (see plugins/treesitter.lua) dropped the
    -- legacy API that Telescope 0.1.x's previewer relies on
    -- (`nvim-treesitter.configs` and `ts_parsers.ft_to_lang`). That path throws
    -- "attempt to call field 'ft_to_lang' (a nil value)" while highlighting
    -- previews. Disable Telescope's built-in treesitter path and start core
    -- treesitter ourselves via the previewer's filetype_hook. `opts.ft` is the
    -- filetype Telescope already detected for the previewed file.
    local function preview_treesitter_hook(_, bufnr, opts)
      local ft = opts.ft
      if ft and ft ~= "" then
        local lang = vim.treesitter.language.get_lang(ft) or ft
        pcall(vim.treesitter.start, bufnr, lang)
      end
      -- Return true so Telescope continues loading the preview contents.
      return true
    end

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "%.git/", "node_modules/", "vendor/" },
        preview = {
          treesitter = false,
          filetype_hook = preview_treesitter_hook,
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
