-- FtVim Python Extra
-- Enable with: { import = "ftvim.plugins.extras.lang.python" }
--
-- This extra includes:
-- - Treesitter and LSP (pyright) come with the core
-- - Linting: flake8 and mypy (installed with Mason)
-- - Virtualenv name in the statusline (core)

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "flake8", "mypy" },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "flake8", "mypy" },
    },
  },
}
