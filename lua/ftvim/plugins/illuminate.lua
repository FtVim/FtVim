return {
	"RRethy/vim-illuminate",
	config = function()
		require("ftvim.core.illuminate").setup()
	end,
	event = "User FileOpened",
	enabled = ftvim.builtin.illuminate.active,
}
