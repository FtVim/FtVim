return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("ftvim.core.gitsigns").setup()
	end,
	event = "User FileOpened",
	cmd = "Gitsigns",
	enabled = ftvim.builtin.gitsigns.active,
}
