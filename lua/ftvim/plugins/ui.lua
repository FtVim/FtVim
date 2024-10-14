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
}
