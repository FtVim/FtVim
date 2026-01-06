-- FtVim 42 School Extra
-- Enable with: { import = "ftvim.plugins.extras.lang.42" }
--
-- This extra includes:
-- - 42 Header (Stdheader)
-- - C Formatter 42 (c_formatter_42.vim) - requires: pip install c-formatter-42
-- - Line counter (ft_count_lines.nvim)
-- - Python linting with flake8 and mypy

return {
  -- 42 Header
  {
    "42Paris/42header",
    cmd = { "Stdheader" },
    keys = {
      { "<leader>Fh", "<cmd>Stdheader<cr>", desc = "Insert 42 Header" },
    },
    init = function()
      -- Set your 42 username and email
      -- You can override these in your config
      vim.g.user42 = vim.g.user42 or os.getenv "USER42" or os.getenv "USER" or "marvin"
      vim.g.mail42 = vim.g.mail42 or os.getenv "MAIL42" or (vim.g.user42 .. "@student.42.fr")
    end,
  },

  -- C Formatter 42
  -- Requires: pip install c-formatter-42
  {
    "cacharle/c_formatter_42.vim",
    ft = { "c", "cpp" },
    keys = {
      { "<leader>Ff", "<cmd>CFormatter42<cr>", desc = "Format C (42 norm)" },
    },
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

  -- Add nvim-lint for Python linting (flake8 + mypy)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      linters_by_ft = {
        python = { "flake8", "mypy" },
      },
      -- Mypy configuration for 42 strict mode
      linters = {
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
    config = function(_, opts)
      local lint = require "lint"

      -- Apply custom linter configurations
      for name, config in pairs(opts.linters or {}) do
        if type(config) == "table" and config.args then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name] or {}, config)
        end
      end

      lint.linters_by_ft = opts.linters_by_ft

      -- Auto-lint on save and text change
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("ftvim_lint", { clear = true }),
        callback = function()
          -- Only lint if buffer is modifiable and has a filetype we care about
          local ft = vim.bo.filetype
          if lint.linters_by_ft[ft] then
            lint.try_lint()
          end
        end,
      })
    end,
  },

  -- Ensure mason installs the Python linters
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "flake8",
        "mypy",
      },
    },
  },

  -- Add keybindings for 42 tools in which-key
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      return opts
    end,
    specs = {
      {
        "folke/which-key.nvim",
        opts = function()
          require("which-key").add {
            { "<leader>F", group = "FtVim/42" },
            { "<leader>Ff", desc = "Format C (42 norm)" },
            { "<leader>Fh", desc = "Insert 42 Header" },
            { "<leader>Fc", desc = "Count Lines (42)" },
          }
        end,
      },
    },
  },
}
