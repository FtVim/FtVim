return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		config = function()
			require("ftvim.core.telescope").setup()
		end,
		dependencies = { "telescope-fzf-native.nvim" },
		lazy = true,
		cmd = "Telescope",
		enabled = ftvim.builtin.telescope.active,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		lazy = true,
		enabled = ftvim.builtin.telescope.active,
	},
}
