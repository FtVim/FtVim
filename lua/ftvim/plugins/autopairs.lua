return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("ftvim.core.autopairs").setup()
	end,
	enabled = ftvim.builtin.autopairs.active,
	dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
}
