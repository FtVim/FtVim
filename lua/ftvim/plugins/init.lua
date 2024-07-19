vim.notify("Starting FtVim")

vim.g.mapleader = (ftvim.leader == "space" and " ") or ftvim.leader

require("ftvim.bootstrap"):init()

local plugins = require("ftvim.plugins.core-plugins")
require("ftvim.core.theme").setup()
require("ftvim.plugin-loader").load({ plugins, ftvim.plugins })

return {
	{ "folke/lazy.nvim", version = "*" },
	{ "FtVim/FtVim", priority = 10000, lazy = false, version = "*" },
}
