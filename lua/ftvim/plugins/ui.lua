return {
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
}
