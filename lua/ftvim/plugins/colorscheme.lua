return {
  {
	"tingey21/telescope-colorscheme-persist.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	lazy = false,
	config = function()
		require("telescope-colorscheme-persist").setup({
			keybind = "<leader>ft"
		})
	end,
  },

  -- vogsphere
  {
    "FtVim/vogsphere.nvim",
    lazy = false,
    opts = {},
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {},
  },

  -- kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    opts = {},
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
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
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}
