return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = true,
    opts = {
        mode = "cursor",
        max_lines = 3,
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
            "bash",
            "c",
            "diff",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
          },
    },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
          if LazyVim.inject.get_upvalue(tsc.toggle, "enabled") then
            LazyVim.info("Enabled Treesitter Context", { title = "Option" })
          else
            LazyVim.warn("Disabled Treesitter Context", { title = "Option" })
          end
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
}
