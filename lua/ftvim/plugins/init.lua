vim.notify("Starting FtVim")

require("ftvim.bootstrap"):init()

return {
	{ "folke/lazy.nvim", version = "*" },
	{ "FtVim/FtVim", priority = 10000, lazy = false, opts = {}, cond = true, version = "*" },
}
