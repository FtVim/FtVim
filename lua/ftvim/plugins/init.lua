vim.notify("Starting FtVim")

require("ftvim.bootstrap"):init()

vim.g.mapleader = (ftvim.leader == "space" and " ") or ftvim.leader

local plugins = require "ftvim.plugins"

require("ftvim.plugin-loader").load { plugins, ftvim.plugins }

require("ftvim.core.theme").setup()

return {
	{ "folke/lazy.nvim", version = "*" },
	{ "FtVim/FtVim", priority = 10000, lazy = false, version = "*" },
}
