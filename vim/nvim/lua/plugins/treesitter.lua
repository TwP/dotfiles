-- Treesitter: fast, accurate syntax highlighting and indentation.
-- Replaces the old regex-based `syntax enable` for supported languages.

return {
  "nvim-treesitter/nvim-treesitter",
  -- Pin to the stable master branch: the newer `main` branch is a rewrite
  -- with a different API and no `nvim-treesitter.configs` module.
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "go", "gomod", "gosum",
      "ruby",
      "javascript", "typescript", "tsx",
      "python",
      "lua", "vim", "vimdoc",
      "json", "yaml", "toml",
      "markdown", "markdown_inline",
      "html", "css", "bash", "git_config", "gitcommit", "diff",
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
