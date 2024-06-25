return {
	"ahmedkhalf/project.nvim",
	config = function()
		require("ftvim.core.project").setup()
	end,
	enabled = ftvim.builtin.project.active,
	event = "VimEnter",
	cmd = "Telescope projects",
}
