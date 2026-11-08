-- Treesitter: fast, accurate syntax highlighting.
-- Uses the nvim-treesitter `main` branch (rewrite for Neovim 0.12+).
-- Highlighting is provided by Neovim core via `vim.treesitter.start()`;
-- this plugin installs/updates parsers and ships the query files.
-- Indentation is intentionally left to Neovim's built-in indent.

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- The main branch does not support lazy-loading.
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local parsers = {
      "go", "gomod", "gosum", "ruby",
      "javascript", "typescript", "tsx", "python",
      "lua", "vim", "vimdoc", "json", "yaml", "toml",
      "markdown", "markdown_inline", "html", "css", "bash",
      "git_config", "gitcommit", "diff",
    }
    require("nvim-treesitter").install(parsers)

    -- Enable treesitter highlighting per filetype. `markdown_inline` has no
    -- standalone filetype (it is injected), so it is omitted here.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true }),
      pattern = {
        "go", "gomod", "gosum", "ruby",
        "javascript", "typescript", "typescriptreact", "python",
        "lua", "vim", "help", "json", "yaml", "toml",
        "markdown", "html", "css", "sh",
        "gitconfig", "gitcommit", "diff",
      },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
