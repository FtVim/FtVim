return {
	"lukas-reineke/indent-blankline.nvim",
	config = function()
		require("lvim.core.indentlines").setup()
	end,
	event = "User FileOpened",
	enabled = lvim.builtin.indentlines.active,
}
