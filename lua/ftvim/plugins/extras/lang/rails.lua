-- FtVim Ruby on Rails Extra
-- Enable with: { import = "ftvim.plugins.extras.lang.rails" }
--
-- This extra includes:
-- - Treesitter: ruby parser
-- - LSP: Solargraph (manual installation required)
-- - TailwindCSS: ERB support
--
-- Prerequisites:
--   gem install solargraph

return {
  -- Treesitter: add ruby parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ruby" },
    },
  },

  -- LSP: Solargraph (manual installation, not via Mason)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {
          mason = false,
          cmd = { "solargraph", "stdio" },
          settings = {
            solargraph = {
              autoformat = true,
              completion = true,
              diagnostics = false,
              folding = true,
              hover = true,
              references = true,
              rename = true,
              symbols = true,
            },
          },
        },
        -- TailwindCSS: ERB support
        tailwindcss = {
          init_options = {
            userLanguages = { eruby = "erb" },
          },
        },
      },
    },
  },
}
