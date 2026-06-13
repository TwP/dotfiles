-- Colorscheme and statusline.

return {
  -- Active colorscheme: nord. priority=1000 + lazy=false means it loads
  -- before everything else so the UI is themed from the very first frame.
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nord")
    end,
  },

  -- Other themes installed but lazy-loaded: switch with `:colorscheme <name>`
  -- (e.g. `:colorscheme tokyonight-storm` or `:colorscheme molokai`).
  { "folke/tokyonight.nvim", lazy = true },
  { "tomasr/molokai", lazy = true },

  -- statusline -> lualine (replaces the hand-rolled statusline.vim).
  -- Shows mode, git branch, diagnostics, filetype, and cursor position.
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "nord",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
