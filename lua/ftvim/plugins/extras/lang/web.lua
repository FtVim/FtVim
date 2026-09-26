-- FtVim Web Extra (ft_transcendence)
-- Enable with: { import = "ftvim.plugins.extras.lang.web" }
--
-- This extra includes:
-- - Treesitter: javascript, typescript, tsx, html and css parsers
-- - LSP: vtsls (TypeScript/JavaScript), eslint, html, cssls, jsonls and tailwindcss
-- - Formatting with prettier (<leader>cf)

local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "javascript", "typescript", "tsx", "html", "css" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {},
        eslint = {},
        html = {},
        cssls = {},
        jsonls = {},
        tailwindcss = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = prettier,
        javascriptreact = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        css = prettier,
        html = prettier,
        json = prettier,
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "prettierd" },
    },
  },
}
