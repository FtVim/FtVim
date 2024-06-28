vim.notify("Starting FtVim")

require("ftvim.bootstrap"):init()
require("ftvim.core.theme").setup()

return {
	{ "folke/lazy.nvim", version = "*" },
	{ "FtVim/FtVim", priority = 10000, lazy = false, version = "*" },
}
