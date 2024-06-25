return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("lvim.core.autopairs").setup()
	end,
	enabled = lvim.builtin.autopairs.active,
	dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
}
