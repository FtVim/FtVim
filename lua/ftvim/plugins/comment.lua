return {
	"numToStr/Comment.nvim",
	config = function()
		require("lvim.core.comment").setup()
	end,
	keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
	event = "User FileOpened",
	enabled = lvim.builtin.comment.active,
}
