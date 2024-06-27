return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("ftvim.core.lualine").setup()
	end,
	event = "VimEnter",
	enabled = ftvim.builtin.lualine.active,
}
