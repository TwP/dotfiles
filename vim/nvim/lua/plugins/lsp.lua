-- Language Server Protocol: VSCode-like features.
-- F12 = go to definition, plus hover, references, rename, diagnostics, etc.
--
-- Uses Mason to auto-install the language servers, and Neovim's built-in LSP
-- client (vim.lsp.config / vim.lsp.enable, available in Neovim 0.11+).

return {
  -- Mason: installs and manages external LSP servers / tools.
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Bridges Mason with the LSP client and auto-enables installed servers.
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig", -- ships the default server configs
      "hrsh7th/cmp-nvim-lsp",  -- completion capabilities for nvim-cmp
    },
    config = function()
      -- Language servers for Mason to install and manage.
      --   ruby_lsp    -> Ruby
      --   ts_ls       -> TypeScript / JavaScript
      --   pyright     -> Python
      --   lua_ls      -> Lua (handy for editing this config)
      --
      -- gopls (Go) is intentionally NOT here: it's installed and managed
      -- globally via mise, and we enable it manually below.
      local servers = { "ruby_lsp", "ts_ls", "pyright", "lua_ls" }

      -- Advertise nvim-cmp's completion capabilities to every server.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- Go: gopls installed globally via mise.
      vim.lsp.enable("gopls")

      -- nvim-lspconfig ships a config for GitLab Duo (gitlab_duo), whose
      -- filetypes include "go", "ruby", "python", etc. We never want its
      -- AI-suggestion server attaching, so explicitly disable it. This is
      -- defensive: nothing enables it today, but this guards against a stray
      -- `:LspStart` or future change auto-launching it.
      vim.lsp.enable("gitlab_duo", false)

      -- Lua server: teach it about the `vim` global so it stops warning.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true, -- calls vim.lsp.enable() for installed servers
      })
    end,
  },

  -- Buffer-local keymaps and behaviour once a language server attaches.
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(event)
          -- Re-enable nvim-cmp's auto-popup for this buffer. Autocomplete is
          -- off by default (see completion.lua); buffers with an LSP get it back.
          local ok, cmp = pcall(require, "cmp")
          if ok then
            cmp.setup.buffer({
              completion = { autocomplete = { cmp.TriggerEvent.TextChanged } },
            })
          end

          local function bmap(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- The headline feature: F12 to jump to definition (like VSCode).
          bmap("<F12>", vim.lsp.buf.definition, "Go to definition")
          -- gd also jumps to definition, the common Vim convention.
          bmap("gd", vim.lsp.buf.definition, "Go to definition")

          -- More VSCode-style navigation:
          bmap("gD", vim.lsp.buf.declaration, "Go to declaration")
          bmap("gi", vim.lsp.buf.implementation, "Go to implementation")
          bmap("gr", vim.lsp.buf.references, "List references") -- Shift+F12 equivalent
          bmap("<S-F12>", vim.lsp.buf.references, "List references")
          bmap("gy", vim.lsp.buf.type_definition, "Go to type definition")

          -- Hover docs (like hovering the mouse in VSCode).
          bmap("K", vim.lsp.buf.hover, "Hover documentation")
          bmap("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")

          -- Refactoring / actions.
          bmap("<F2>", vim.lsp.buf.rename, "Rename symbol")
          bmap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          bmap("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })

          -- Diagnostics (the red/yellow squiggles).
          bmap("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
          bmap("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          bmap("<leader>e", vim.diagnostic.open_float, "Show diagnostic")
          bmap("<leader>q", vim.diagnostic.setloclist, "Diagnostics to loclist")

          -- Format the current buffer.
          bmap("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")

          -- Go: format and fix up imports on every save, the gofmt-on-save
          -- workflow. vim-go used to own this, but its save hook is disabled
          -- (see editor.lua) because it shells out to binaries we don't install.
          -- gopls already advertises documentFormattingProvider and the
          -- source.organizeImports code action, so drive both from here.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "gopls" then
            -- LspAttach can fire again for a buffer (:LspRestart, :edit), so drop
            -- any hook already registered for *this* buffer first. Clearing by
            -- buffer rather than by group leaves other Go buffers untouched.
            local group = vim.api.nvim_create_augroup("UserGoFormatOnSave", { clear = false })
            vim.api.nvim_clear_autocmds({ group = group, buffer = event.buf })

            vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              buffer = event.buf,
              desc = "gopls: organize imports and format",
              callback = function()
                -- Organize imports first: it returns a workspace edit, and
                -- formatting afterwards would otherwise overwrite it.
                local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
                params.context = { only = { "source.organizeImports" } }
                local results = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                for _, res in pairs(results or {}) do
                  for _, action in pairs(res.result or {}) do
                    if action.edit then
                      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                    end
                  end
                end
                vim.lsp.buf.format({ bufnr = event.buf, timeout_ms = 3000 })
              end,
            })
          end
        end,
      })

      -- Nicer diagnostic display.
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })
    end,
  },
}
