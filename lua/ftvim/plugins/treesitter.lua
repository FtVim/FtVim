return {
	"nvim-treesitter/nvim-treesitter",
	-- run = ":TSUpdate",
	config = function()
		local utils = require("ftvim.utils")
		local path = utils.join_paths(get_runtime_dir(), "site", "pack", "lazy", "opt", "nvim-treesitter")
		vim.opt.rtp:prepend(path) -- treesitter needs to be before nvim's runtime in rtp
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
}
