return {
	"goolord/alpha-nvim",
	config = function()
		require("ftvim.core.alpha").setup()
	end,
	enabled = ftvim.builtin.alpha.active,
	event = "VimEnter",
}
