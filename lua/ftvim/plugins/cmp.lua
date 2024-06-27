return {
	{
		"hrsh7th/nvim-cmp",
		config = function()
			if ftvim.builtin.cmp then
				require("ftvim.core.cmp").setup()
			end
		end,
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"cmp-nvim-lsp",
			"cmp_luasnip",
			"cmp-buffer",
			"cmp-path",
			"cmp-cmdline",
		},
	},
	{ "hrsh7th/cmp-nvim-lsp", lazy = true },
	{ "saadparwaiz1/cmp_luasnip", lazy = true },
	{ "hrsh7th/cmp-buffer", lazy = true },
	{ "hrsh7th/cmp-path", lazy = true },
	{
		"hrsh7th/cmp-cmdline",
		lazy = true,
		enabled = ftvim.builtin.cmp and ftvim.builtin.cmp.cmdline.enable or false,
	},
}
