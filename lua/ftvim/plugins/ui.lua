return {
	{

		"lukas-reineke/indent-blankline.nvim",

		main = "ibl",

		config = function()
			require("ibl").setup()
		end,
		opts = {},
	},
	-- Dashboard
	{

		"goolord/alpha-nvim",

		config = function()
			require("ftvim.loader.alpha").setup()
		end,

		event = "VimEnter",
	},
	-- Bufferline
	{

		"akinsho/bufferline.nvim",

		config = function()
			require("ftvim.loader.bufferline").setup()
		end,

		branch = "main",

		event = "VimEnter",
	},
	-- Illuminate
	{
		"RRethy/vim-illuminate",

		config = function()
			require("ftvim.loader.illuminate").setup()
		end,

		event = "VimEnter",
	},
	-- Mini.indentscope
	{
		"echasnovski/mini.indentscope",
		version = false,
		config = function()
			require("ftvim.loader.indentscope").setup()
		end,
	},
	-- Notifications
	{
		"rcarriga/nvim-notify",
		event = "BufLeave",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss All Notifications",
			},
		},
		config = function()
			require("ftvim.loader.notifications").setup()
		end,
	},
	-- Icons
	{
		"nvim-tree/nvim-web-devicons",

		lazy = true,
	},
	-- Dressing.nvim
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	-- Lualine
	-- {

	-- 	-- "hoob3rt/lualine.nvim",

	-- 	"nvim-lualine/lualine.nvim",

	-- 	config = function()
	-- 		require("ftvim.loader.lualine").setup()
	-- 	end,

	-- 	event = "VimEnter",

	-- },
}
