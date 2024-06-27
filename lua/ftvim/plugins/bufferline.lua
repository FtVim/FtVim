return {
	"akinsho/bufferline.nvim",
	config = function()
		require("ftvim.core.bufferline").setup()
	end,
	branch = "main",
	event = "User FileOpened",
	enabled = ftvim.builtin.bufferline.active,
}
