return {
	{
		"folke/tokyonight.nvim",
		lazy = not vim.startswith(ftvim.colorscheme, "tokyonight"),
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = not vim.startswith(ftvim.colorscheme, "kanagawa"),
	},
	{
		"KabbAmine/yowish.vim",
		lazy = not vim.startswith(ftvim.colorscheme, "yowish"),
	},
}
