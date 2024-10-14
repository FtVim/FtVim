return {
	-- file explorer
	{
		"nvim-tree/nvim-tree.lua",
		cmd = {"NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
		config = function()
			require("ftvim.loader.nvim-tree").setup()
		end
	},
	{
		"folke/which-key.nvim",
		event = "BufEnter",
		opts = {},
		config = function()
			require("ftvim.loader.which-key").setup()
		end,
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
	},

	-- Motions
	{ 
		'echasnovski/mini.ai',
		version = false,
		config = function()
			require("mini.ai").setup()
		end
	},
}
