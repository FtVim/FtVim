return {
	"folke/which-key.nvim",
	config = function()
		require("ftvim.core.which-key").setup()
	end,
	cmd = "WhichKey",
	event = "VeryLazy",
	enabled = ftvim.builtin.which_key.active,
}
