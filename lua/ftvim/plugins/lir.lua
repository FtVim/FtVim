return {
	"tamago324/lir.nvim",
	config = function()
		require("ftvim.core.lir").setup()
	end,
	enabled = ftvim.builtin.lir.active,
	event = "User DirOpened",
}
