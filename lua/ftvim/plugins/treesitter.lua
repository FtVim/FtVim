return {
	{

		"nvim-treesitter/nvim-treesitter",
		-- run = ":TSUpdate",
		config = function()
			require("ftvim.core.treesitter").setup()
		end,
		cmd = {
			"TSInstall",
			"TSUninstall",
			"TSUpdate",
			"TSUpdateSync",
			"TSInstallInfo",
			"TSInstallSync",
			"TSInstallFromGrammar",
		},
		event = "User FileOpened",
	},
	{
		-- Lazy loaded by Comment.nvim pre_hook
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
	},
}
