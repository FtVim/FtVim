-- FtVim C++ Extra (CPP Modules, ft_irc, webserv)
-- Enable with: { import = "ftvim.plugins.extras.lang.cpp" }
--
-- This extra includes:
-- - .tpp files (template implementations) are C++
-- - Formatting with clang-format (<leader>cf)
-- - clangd and the cpp treesitter parser come with the core
--
-- Tip: with lang.42, :FtVimClass Name creates a class in Orthodox Canonical Form and
-- :FtVimCompileFlags makes clangd use -std=c++98 and your include directories.

vim.filetype.add { extension = { tpp = "cpp" } }

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "clang-format" },
    },
  },
}
