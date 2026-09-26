-- FtVim 42 School Extra
-- Enable with: { import = "ftvim.plugins.extras.lang.42" }
--
-- This extra includes:
-- - 42 header (:Stdheader, <leader>Fh), inserted automatically in new files
-- - Norminette diagnostics while you type, and a counter in the statusline
-- - C formatter 42 (<leader>Ff, or on save with vim.g.ftvim_autoformat = true)
-- - Line counter (ft_count_lines.nvim)
-- - Exam mode: no LSP, completion, diagnostics or Copilot (:FtVimExam, <leader>Fe)
-- - Pre-submission checks: norminette, Makefile, relink, forbidden functions (:FtVimCheck)
-- - compile_commands.json generated automatically with compiledb, so clangd knows your flags
--   and include paths (:FtVimCompileDb, <leader>Fg)
-- - :FtVimMake, :FtVimNorm, :FtVimValgrind, :FtVimClass, :FtVimCompileFlags
-- - C/C++ debugging (extras.dap) and Python piscine linting (extras.lang.python)
--
-- Requires: pipx install norminette c-formatter-42 compiledb
--
-- Options (set them in lua/config/options.lua):
--   vim.g.user42 / vim.g.mail42      your 42 login and email (default: $USER42 / $MAIL42 / $USER)
--   vim.g.ft42_auto_header = false   don't insert the header in new files
--   vim.g.ft42_compile_db = false    don't generate compile_commands.json automatically
--   vim.g.ft42_allowed_functions     allowed functions for :FtVimCheck, e.g. { "malloc", "free", "write" }

-- .h files are C for 42 (Neovim detects them as C++ by default)
vim.g.c_syntax_for_h = 1

require("ftvim.ft42").setup()

return {
  { import = "ftvim.plugins.extras.lang.python" },
  { import = "ftvim.plugins.extras.dap" },

  -- 42 Header
  {
    "42Paris/42header",
    -- Loaded when opening files so it updates the "Updated:" line on save
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Stdheader" },
    keys = {
      { "<leader>Fh", "<cmd>Stdheader<cr>", desc = "Insert 42 Header" },
    },
    init = function()
      -- Set your 42 username and email (you can override these in your config)
      vim.g.user42 = vim.g.user42 or os.getenv "USER42" or os.getenv "USER" or "marvin"
      vim.g.mail42 = vim.g.mail42 or os.getenv "MAIL42" or (vim.g.user42 .. "@student.42barcelona.com")
    end,
  },

  -- Line counter
  {
    "FtVim/ft_count_lines.nvim",
    ft = { "c", "cpp" },
    keys = {
      { "<leader>Fc", "<cmd>FtCountLines<cr>", desc = "Count Lines (42)" },
    },
    config = function()
      require("ft_count_lines").setup()
    end,
  },

  -- Norminette
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        c = { "norminette" },
      },
      linters = {
        norminette = function()
          return require("ftvim.ft42.norminette").linter()
        end,
        -- Mypy flags used in the 42 Python piscine
        mypy = {
          args = {
            "--warn-return-any",
            "--warn-unused-ignores",
            "--ignore-missing-imports",
            "--disallow-untyped-defs",
            "--check-untyped-defs",
            "--show-column-numbers",
            "--show-error-end",
            "--hide-error-context",
            "--no-color-output",
            "--no-error-summary",
            "--no-pretty",
          },
        },
      },
    },
  },

  -- C formatter 42 (pip install --user c-formatter-42)
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>Ff",
        function()
          require("conform").format { formatters = { "c_formatter_42" }, async = true }
        end,
        mode = { "n", "v" },
        desc = "Format C (42 norm)",
      },
    },
    opts = {
      formatters_by_ft = {
        c = { "c_formatter_42" },
      },
      formatters = {
        c_formatter_42 = {
          command = "c_formatter_42",
          stdin = true,
        },
      },
    },
  },

  -- clangd: never add #includes on its own (the subjects restrict which headers/functions you can use)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--function-arg-placeholders=1",
          },
        },
      },
    },
  },

  -- 42 snippets (hguard, main, 42make, ...)
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        providers = {
          snippets = {
            opts = {
              search_paths = {
                vim.fn.stdpath "config" .. "/snippets",
                require("ftvim.util").root() .. "/snippets/42",
              },
            },
          },
        },
      },
    },
  },

  -- Statusline: norminette counter and exam mode indicator
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local norminette = require "ftvim.ft42.norminette"
      local has_norminette = vim.fn.executable "norminette" == 1
      table.insert(opts.sections.lualine_x, 1, {
        function()
          local count = norminette.count()
          return count == 0 and "Norm ✓" or ("Norm ✗ " .. count)
        end,
        cond = function()
          return has_norminette and vim.bo.filetype == "c" and norminette.count() ~= nil
        end,
        color = function()
          return norminette.count() == 0 and "DiagnosticOk" or "DiagnosticError"
        end,
      })
      table.insert(opts.sections.lualine_x, 1, {
        function()
          return "EXAM"
        end,
        cond = function()
          return package.loaded["ftvim.ft42.exam"] ~= nil and require("ftvim.ft42.exam").enabled
        end,
        color = "DiagnosticWarn",
      })
    end,
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>F", group = "FtVim/42" },
        { "<leader>Fe", "<cmd>FtVimExam<cr>", desc = "Toggle Exam Mode" },
        { "<leader>FC", "<cmd>FtVimCheck<cr>", desc = "Check Project (before submitting)" },
        { "<leader>Fn", "<cmd>FtVimNorm<cr>", desc = "Norminette (project)" },
        { "<leader>Fm", "<cmd>FtVimMake<cr>", desc = "Make" },
        { "<leader>Fv", "<cmd>FtVimValgrind<cr>", desc = "Valgrind" },
        { "<leader>Fg", "<cmd>FtVimCompileDb<cr>", desc = "Generate compile_commands.json" },
      },
    },
  },
}
