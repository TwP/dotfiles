-- Colorscheme and statusline.

return {
  -- Active colorscheme: kanagawa-wave. priority=1000 + lazy=false means it
  -- loads before everything else so the UI is themed from the very first frame.
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        -- Turn off italics everywhere (comments, keywords, statements).
        commentStyle = { italic = false },
        keywordStyle = { italic = false },
        statementStyle = { italic = false },
        -- Lighten the window dividers.
        overrides = function(colors)
          return {
            -- WinSeparator = { fg = colors.theme.ui.fg },
            WinSeparator = { fg = colors.palette.crystalBlue },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },

  -- Other themes installed but lazy-loaded: switch with `:colorscheme <name>`
  -- (e.g. `:colorscheme tokyonight-storm` or `:colorscheme molokai`).
  { "folke/tokyonight.nvim", lazy = true },
  { "tomasr/molokai", lazy = true },
  { "shaunsingh/nord.nvim", lazy = true },

  -- statusline -> lualine (replaces the hand-rolled statusline.vim).
  -- Shows mode, git branch, diagnostics, filetype, and cursor position.
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "kanagawa",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "lsp_status", "progress" },
        lualine_z = { "location" },
      },
      -- Native tabpage line (manages tabs, not buffers). `mode = 2` shows the
      -- tab number plus the active window's filename for each tabpage.
      tabline = {
        lualine_a = {
          {
            "tabs",
            mode = 2,
            max_length = vim.o.columns,
            -- `mode = 2` labels each tab with its *active* window's buffer.
            -- When nvim-tree is focused that's "NvimTree"; swap in the first
            -- real file buffer in the tab instead so the label stays useful.
            fmt = function(name, context)
              -- nvim-tree buffers are named "NvimTree_1", "NvimTree_2", ...
              if not name:match("^NvimTree_%d+$") then
                return name
              end
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(context.tabId)) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype ~= "NvimTree" then
                  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
                  return fname ~= "" and fname or "[No Name]"
                end
              end
              return name
            end,
          },
        },
      },
    },
  },
}
