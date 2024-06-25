return {
	-- Status Line and Bufferline
	-- "hoob3rt/lualine.nvim",
	"nvim-lualine/lualine.nvim",
	-- "Lunarvim/lualine.nvim",
	config = function()
		require("ftvim.core.lualine").setup()
	end,
	event = "VimEnter",
	enabled = ftvim.builtin.lualine.active,
}
