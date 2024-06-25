return {
	"numToStr/Comment.nvim",
	config = function()
		require("ftvim.core.comment").setup()
	end,
	keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
	event = "User FileOpened",
	enabled = ftvim.builtin.comment.active,
}
