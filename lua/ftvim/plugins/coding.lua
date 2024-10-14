return {
	-- Autopairs
	{

		"windwp/nvim-autopairs",

		event = "InsertEnter",

		config = function()
			require("ftvim.loader.autopairs").setup()
		end,

		dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
	},
	-- Nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer", -- source for text in buffer
			"hrsh7th/cmp-path", -- source for file system paths
			{
				"L3MON4D3/LuaSnip",
				-- follow latest release.
				version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			},
			"saadparwaiz1/cmp_luasnip", -- for autocompletion
			"rafamadriz/friendly-snippets", -- useful snippets
			"onsails/lspkind.nvim", -- vs-code like pictograms
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			require("ftvim.loader.cmp").setup()
		end,
	},
	-- Comments
	{
		"numToStr/Comment.nvim",

		config = function()
			require("ftvim.loader.comment").setup()
		end,

		keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },

		event = "VeryLazy",

	},
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- Mason and lsp
	{
		"williamboman/mason.nvim",
		config = function()
			require("ftvim.loader.mason").setup()
		end,
		build = ":MasonUpdate",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("ftvim.loader.mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim"
		},
		config = function()
			require("ftvim.loader.lsp").setup()
		end,
	},
}
