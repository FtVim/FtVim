return {
	"lukas-reineke/indent-blankline.nvim",
	config = function()
		require("ftvim.core.indentlines").setup()
	end,
	event = "User FileOpened",
	enabled = ftvim.builtin.indentlines.active,
}
