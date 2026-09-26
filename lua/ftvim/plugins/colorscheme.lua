-- FtVim Colorschemes

return {
  -- Catppuccin (default)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        illuminate = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        neotree = true,
        semantic_tokens = true,
        snacks = true,
        treesitter = true,
        which_key = true,
      },
    },
  },

  -- Tokyo Night
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "moon",
    },
  },

  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {},
  },
}
