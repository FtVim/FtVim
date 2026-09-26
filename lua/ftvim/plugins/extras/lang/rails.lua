-- FtVim Ruby on Rails Extra
-- Enable with: { import = "ftvim.plugins.extras.lang.rails" }
--
-- This extra includes:
-- - Treesitter: ruby and ERB (embedded_template) parsers
-- - LSP: Solargraph (manual installation required)
-- - TailwindCSS: ERB support
-- - Ruby: 2-space indentation and <leader>rr to run the current file
--
-- Prerequisites:
--   gem install solargraph

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ftvim_rails", { clear = true }),
  pattern = "ruby",
  callback = function(event)
    vim.bo[event.buf].shiftwidth = 2
    vim.bo[event.buf].tabstop = 2
    vim.bo[event.buf].softtabstop = 2
    vim.bo[event.buf].expandtab = true
    vim.keymap.set("n", "<leader>rr", "<cmd>!ruby %<cr>", { buffer = event.buf, desc = "Run Ruby file" })
  end,
})

return {
  -- Treesitter: add ruby parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ruby", "embedded_template" },
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
